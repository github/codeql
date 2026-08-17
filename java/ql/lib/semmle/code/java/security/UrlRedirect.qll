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

/**
 * An expression appended to a Spring `"redirect:"` view-name prefix from a request handler or a
 * helper called by one.
 */
private class SpringUrlRedirectPrefixSink extends UrlRedirectSink {
  SpringUrlRedirectPrefixSink() {
    isSpringMvcViewResult(this.asExpr()) and
    appendedToRedirectPrefix(this)
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
    (
      value.getParent*() = ret.getExpr()
      or
      DataFlow::localFlow(DataFlow::exprNode(value), DataFlow::exprNode(ret.getExpr()))
    )
  )
}

/** Holds if `value` contributes to a view returned from a Spring MVC request handler. */
pragma[nomagic]
private predicate isSpringMvcViewResult(Expr value) {
  contributesToReturn(value) and
  value.getEnclosingCallable() instanceof SpringRequestMappingMethod and
  not value.getEnclosingCallable().(SpringRequestMappingMethod).isResponseBody()
  or
  contributesToReturn(value) and
  exists(MethodCall call |
    call.getCallee().getSourceDeclaration() = value.getEnclosingCallable() and
    isSpringMvcViewResult(call)
  )
}

private class SpringRedirectViewType extends RefType {
  SpringRedirectViewType() {
    this.getASupertype*().hasQualifiedName("org.springframework.web.servlet.view", "RedirectView")
  }
}

/** A URL passed to a Spring `RedirectView` constructor. */
private class SpringRedirectViewSink extends UrlRedirectSink {
  SpringRedirectViewSink() {
    exists(ClassInstanceExpr newRedirectView |
      newRedirectView.getConstructedType() instanceof SpringRedirectViewType and
      isSpringMvcViewResult(newRedirectView) and
      this.asExpr() = newRedirectView.getArgument(0)
    )
  }
}

/** A URL passed to `setUrl` on a Spring `RedirectView` that is returned by a request handler. */
private class SpringRedirectViewSetUrlSink extends UrlRedirectSink {
  SpringRedirectViewSetUrlSink() {
    exists(MethodCall setUrl |
      setUrl.getMethod().hasName("setUrl") and
      setUrl.getMethod().getNumberOfParameters() = 1 and
      setUrl
          .getMethod()
          .getDeclaringType()
          .getASupertype*()
          .hasQualifiedName("org.springframework.web.servlet.view", "AbstractUrlBasedView") and
      setUrl.getQualifier().getType() instanceof SpringRedirectViewType and
      isSpringMvcViewResult(setUrl.getQualifier()) and
      this.asExpr() = setUrl.getArgument(0)
    )
  }
}

private class DefaultUrlRedirectSanitizer extends UrlRedirectSanitizer instanceof RequestForgerySanitizer
{ }
