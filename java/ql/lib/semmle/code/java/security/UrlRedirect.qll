/** Provides classes to reason about URL redirect attacks. */
overlay[local?]
module;

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.ApacheHttp
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.dataflow.SSA
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
    exists(Expr name |
      (isSpringMvcReturnedString(name) or isSpringModelAndViewName(name)) and
      this.asExpr() = getRedirectTarget(name) and
      TaintTracking::localTaint(this, DataFlow::exprNode(name))
    )
  }
}

/** A call to a helper that returns a Spring `"redirect:"` view name. */
private class SpringUrlRedirectHelperSink extends UrlRedirectSink {
  SpringUrlRedirectHelperSink() {
    exists(Expr name, MethodCall call |
      this.asExpr() = call and
      (isSpringMvcReturnedString(name) or isSpringModelAndViewName(name)) and
      call = getViewNamePrefix(name) and
      returnsRedirectViewName(call.getCallee().getSourceDeclaration())
    )
  }
}

/** The exact Spring redirect prefix, without a fixed target path or host. */
private class SpringRedirectPrefix extends CompileTimeConstantExpr {
  SpringRedirectPrefix() { this.getStringValue() = "redirect:" }
}

/** Relates a local read to its reaching SSA definitions. */
private predicate localViewDefinition(Expr value, SsaDefinition def) {
  value.getUnderlyingExpr().(VarRead).getVariable() instanceof LocalVariableDecl and
  def.getARead() = value.getUnderlyingExpr()
}

/** Gets a possible local view-name value, following conditional branches and SSA inputs. */
pragma[nomagic]
private Expr getAViewNameValue(Expr value) {
  result = value.getUnderlyingExpr() and
  not result instanceof ConditionalExpr and
  (
    not exists(SsaDefinition def | localViewDefinition(value, def))
    or
    exists(SsaDefinition def |
      localViewDefinition(value, def) and
      not exists(def.getAnUltimateDefinition().(SsaExplicitWrite).getValue())
    )
  )
  or
  exists(SsaDefinition def |
    localViewDefinition(value, def) and
    result = getAViewNameValue(def.getAnUltimateDefinition().(SsaExplicitWrite).getValue())
  )
  or
  result = getAViewNameValue(value.getUnderlyingExpr().(ConditionalExpr).getABranchExpr())
}

/** Gets a possible leading expression, following only left-hand concatenation. */
pragma[nomagic]
private Expr getViewNamePrefix(Expr value) {
  result = getAViewNameValue(value) and not result instanceof AddExpr
  or
  result = getViewNamePrefix(getAViewNameValue(value).(AddExpr).getLeftOperand())
}

/** Gets the target appended to an exact redirect prefix at the start of a view name. */
pragma[nomagic]
private Expr getRedirectTarget(Expr value) {
  exists(AddExpr add | add = getAViewNameValue(value) |
    getViewNamePrefix(add.getLeftOperand()) instanceof SpringRedirectPrefix and
    result = add.getRightOperand()
    or
    result = getRedirectTarget(add.getLeftOperand())
  )
}

/** Holds if `value` contributes to a view returned from a Spring MVC request handler. */
pragma[nomagic]
private predicate isSpringMvcViewResult(Expr value) {
  exists(ReturnStmt ret |
    ret.getEnclosingCallable() = value.getEnclosingCallable() and
    ret.getEnclosingCallable() instanceof SpringRequestMappingMethod and
    DataFlow::localFlow(DataFlow::exprNode(value), DataFlow::exprNode(ret.getExpr()))
  )
  or
  exists(ClassInstanceExpr newModelAndView |
    newModelAndView
        .getConstructedType()
        .hasQualifiedName("org.springframework.web.servlet", "ModelAndView") and
    newModelAndView
        .getConstructor()
        .getParameter(0)
        .getType()
        .(RefType)
        .hasQualifiedName("org.springframework.web.servlet", "View") and
    DataFlow::localFlow(DataFlow::exprNode(value),
      DataFlow::exprNode(newModelAndView.getArgument(0))) and
    isSpringMvcViewResult(newModelAndView)
  )
}

/** Holds if `name` is a string view name returned by a request handler. */
private predicate isSpringMvcReturnedString(Expr name) {
  exists(ReturnStmt ret, SpringRequestMappingMethod handler |
    handler = name.getEnclosingCallable() and
    ret.getEnclosingCallable() = handler and
    not handler.isResponseBody() and
    not handler instanceof SpringModelAttributeMethod and
    name = ret.getExpr()
  )
}

/** Holds if `name` is the string view name of a returned `ModelAndView`. */
private predicate isSpringModelAndViewName(Expr name) {
  exists(ClassInstanceExpr newModelAndView |
    newModelAndView
        .getConstructedType()
        .hasQualifiedName("org.springframework.web.servlet", "ModelAndView") and
    newModelAndView.getConstructor().getParameter(0).getType() instanceof TypeString and
    name = newModelAndView.getArgument(0) and
    isSpringMvcViewResult(newModelAndView)
  )
}

/** Holds if a name is constant or is constructed from the exact redirect prefix. */
private predicate isConstantOrRedirectViewName(Expr name) {
  exists(getAViewNameValue(name)) and
  forall(Expr value | value = getAViewNameValue(name) |
    exists(value.(CompileTimeConstantExpr).getStringValue())
    or
    exists(getViewNamePrefix(value)) and
    forall(Expr prefix | prefix = getViewNamePrefix(value) | prefix instanceof SpringRedirectPrefix)
  )
}

/** Holds if `callable` returns redirect names without mixing in other dynamic view names. */
pragma[nomagic]
private predicate returnsRedirectViewName(Callable callable) {
  exists(Expr target, ReturnStmt ret |
    callable.(Method).getReturnType() instanceof TypeString and
    forall(ReturnStmt r | r.getEnclosingCallable() = callable |
      isConstantOrRedirectViewName(r.getExpr())
    ) and
    ret.getEnclosingCallable() = callable and
    target = getRedirectTarget(ret.getExpr()) and
    TaintTracking::localTaint(DataFlow::exprNode(target), DataFlow::exprNode(ret.getExpr()))
  )
  or
  exists(MethodCall call, ReturnStmt ret |
    callable.(Method).getReturnType() instanceof TypeString and
    ret = unique(ReturnStmt r | r.getEnclosingCallable() = callable) and
    call = unique(Expr prefix | prefix = getViewNamePrefix(ret.getExpr())) and
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
