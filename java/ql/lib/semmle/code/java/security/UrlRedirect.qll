/** Provides classes to reason about URL redirect attacks. */
overlay[local?]
module;

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.ApacheHttp
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.dataflow.StringPrefixes
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.frameworks.JaxWS
private import semmle.code.java.frameworks.spring.SpringController
private import semmle.code.java.security.RequestForgery

/** A URL redirection sink. */
abstract class UrlRedirectSink extends ApiSinkNode { }

/** A URL redirection sanitizer. */
abstract class UrlRedirectSanitizer extends DataFlow::Node { }

/** A default sink represeting methods susceptible to URL redirection attacks. */
private class DefaultUrlRedirectSink extends UrlRedirectSink {
  DefaultUrlRedirectSink() { sinkNode(this, "url-redirection") }
}

/** A Servlet URL redirection sink. */
private class ServletUrlRedirectSink extends UrlRedirectSink {
  ServletUrlRedirectSink() {
    exists(MethodCall ma |
      ma.getMethod() instanceof HttpServletResponseSendRedirectMethod and
      this.asExpr() = ma.getArgument(0)
    )
    or
    exists(MethodCall ma |
      ma.getMethod() instanceof ResponseSetHeaderMethod or
      ma.getMethod() instanceof ResponseAddHeaderMethod
    |
      ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "Location" and
      this.asExpr() = ma.getArgument(1)
    )
  }
}

/** A URL redirection sink from Apache Http components. */
private class ApacheUrlRedirectSink extends UrlRedirectSink {
  ApacheUrlRedirectSink() {
    exists(ApacheHttpSetHeader c |
      c.getName().(CompileTimeConstantExpr).getStringValue() = "Location" and
      this.asExpr() = c.getValue()
    )
  }
}

/** An expression appended to a Spring `"redirect:"` view-name returned by a request handler. */
private class SpringUrlRedirectPrefixSink extends UrlRedirectSink {
  SpringUrlRedirectPrefixSink() {
    appendedToRedirectPrefix(this) and
    (
      isSpringMvcReturnedString(this.asExpr())
      or
      isSpringModelAndViewName(this.asExpr())
    )
  }
}

/** A call to a helper that returns a Spring `"redirect:"` view name. */
private class SpringUrlRedirectHelperSink extends UrlRedirectSink {
  SpringUrlRedirectHelperSink() {
    exists(MethodCall call |
      this.asExpr() = call and
      isSpringMvcViewResult(call) and
      returnsRedirectViewName(call.getCallee().getSourceDeclaration())
    )
  }
}

pragma[nomagic]
private predicate appendedToRedirectPrefix(DataFlow::ExprNode exprNode) {
  exists(SpringRedirectPrefix prefix | exprNode.asExpr() = prefix.getAnAppendedExpression())
}

private class SpringRedirectPrefix extends InterestingPrefix {
  SpringRedirectPrefix() { this.getStringValue() = "redirect:" }

  override int getOffset() { result = 0 }
}

private predicate contributesToReturn(Expr value) {
  exists(ReturnStmt ret |
    ret.getEnclosingCallable() = value.getEnclosingCallable() and
    DataFlow::localFlow(DataFlow::exprNode(value), DataFlow::exprNode(ret.getExpr()))
  )
}

/** Holds if `value` contributes string content to the return value of its callable. */
private predicate contributesToReturnedString(Expr value) {
  exists(ReturnStmt ret |
    ret.getEnclosingCallable() = value.getEnclosingCallable() and
    TaintTracking::localTaint(DataFlow::exprNode(value), DataFlow::exprNode(ret.getExpr()))
  )
}

/** Holds if `value` contributes to a view returned from a Spring MVC request handler. */
pragma[nomagic]
private predicate isSpringMvcViewResult(Expr value) {
  contributesToReturn(value) and
  value.getEnclosingCallable() instanceof SpringRequestMappingMethod and
  not value.getEnclosingCallable().(SpringRequestMappingMethod).isResponseBody()
}

/** Holds if `value` contributes string content to a view name returned by a request handler. */
private predicate isSpringMvcReturnedString(Expr value) {
  contributesToReturnedString(value) and
  value.getEnclosingCallable() instanceof SpringRequestMappingMethod and
  not value.getEnclosingCallable().(SpringRequestMappingMethod).isResponseBody()
}

/** Holds if `value` contributes to the view name of a returned `ModelAndView`. */
private predicate isSpringModelAndViewName(Expr value) {
  exists(ClassInstanceExpr newModelAndView |
    newModelAndView
        .getConstructedType()
        .hasQualifiedName("org.springframework.web.servlet", "ModelAndView") and
    TaintTracking::localTaint(DataFlow::exprNode(value),
      DataFlow::exprNode(newModelAndView.getArgument(0))) and
    isSpringMvcViewResult(newModelAndView)
  )
}

/** Holds if `callable` returns a view name constructed with the Spring `"redirect:"` prefix. */
pragma[nomagic]
private predicate returnsRedirectViewName(Callable callable) {
  exists(DataFlow::ExprNode appended, ReturnStmt ret |
    appendedToRedirectPrefix(appended) and
    appended.asExpr().getEnclosingCallable() = callable and
    ret.getEnclosingCallable() = callable and
    TaintTracking::localTaint(appended, DataFlow::exprNode(ret.getExpr()))
  )
  or
  exists(MethodCall call |
    call.getEnclosingCallable() = callable and
    contributesToReturn(call) and
    returnsRedirectViewName(call.getCallee().getSourceDeclaration())
  )
}

/** A URL passed to a Spring `RedirectView` constructor. */
private class SpringRedirectViewSink extends UrlRedirectSink {
  SpringRedirectViewSink() {
    exists(ClassInstanceExpr newRedirectView |
      newRedirectView
          .getConstructedType()
          .hasQualifiedName("org.springframework.web.servlet.view", "RedirectView") and
      isSpringMvcViewResult(newRedirectView) and
      this.asExpr() = newRedirectView.getArgument(0)
    )
  }
}

/** A URL passed to `setUrl` on a Spring `RedirectView` that is returned by a request handler. */
private class SpringRedirectViewSetUrlSink extends UrlRedirectSink {
  SpringRedirectViewSetUrlSink() {
    exists(MethodCall setUrl |
      setUrl
          .getMethod()
          .getSourceDeclaration()
          .hasQualifiedName("org.springframework.web.servlet.view", "AbstractUrlBasedView", "setUrl") and
      setUrl
          .getQualifier()
          .getType()
          .(RefType)
          .getASupertype*()
          .hasQualifiedName("org.springframework.web.servlet.view", "RedirectView") and
      isSpringMvcViewResult(setUrl.getQualifier()) and
      this.asExpr() = setUrl.getArgument(0)
    )
  }
}

private class DefaultUrlRedirectSanitizer extends UrlRedirectSanitizer instanceof RequestForgerySanitizer
{ }
