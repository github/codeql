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
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.controlflow.Dominance
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
    exists(Expr name, SpringRedirectPrefix prefix |
      (isSpringMvcReturnedString(name) or isSpringModelAndViewName(name)) and
      prefix = getViewNamePrefix(name) and
      appendedToRedirectPrefix(prefix, this) and
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

pragma[nomagic]
private predicate appendedToRedirectPrefix(SpringRedirectPrefix prefix, DataFlow::ExprNode exprNode) {
  exprNode.asExpr() = prefix.getAnAppendedExpression()
}

private class SpringRedirectPrefix extends InterestingPrefix {
  SpringRedirectPrefix() { this.getStringValue() = "redirect:" }

  override int getOffset() { result = 0 }
}

/** Relates a local read to its reaching SSA definitions. */
private predicate localViewDefinition(Expr value, SsaDefinition def) {
  value.getUnderlyingExpr().(VarRead).getVariable() instanceof LocalVariableDecl and
  def.getARead() = value.getUnderlyingExpr()
}

/** Gets a terminal local value, retaining unknown or merged definitions as unknown reads. */
pragma[nomagic]
private Expr getALocalViewValue(Expr value) {
  result = value.getUnderlyingExpr() and
  (
    not exists(SsaDefinition def | localViewDefinition(value, def))
    or
    exists(SsaDefinition def |
      localViewDefinition(value, def) and
      not exists(def.(SsaExplicitWrite).getValue())
    )
  )
  or
  exists(SsaExplicitWrite def |
    localViewDefinition(value, def) and
    result = getALocalViewValue(def.getValue())
  )
}

/** Gets the unique local value, excluding uncertain origins. */
private Expr getLocalViewValue(Expr value) {
  result = unique(Expr terminal | terminal = getALocalViewValue(value))
}

/** Gets the leading expression of a complete view name, following only left-hand concatenation. */
pragma[nomagic]
private Expr getViewNamePrefix(Expr value) {
  result = getLocalViewValue(value) and not result instanceof AddExpr
  or
  result = getViewNamePrefix(getLocalViewValue(value).(AddExpr).getLeftOperand())
}

/** Holds if a call writes the URL or view-name property of a Spring view. */
private predicate isSpringViewPropertyWrite(MethodCall call, string property) {
  property = "url" and
  call.getMethod()
      .getSourceDeclaration()
      .hasQualifiedName("org.springframework.web.servlet.view", "AbstractUrlBasedView", "setUrl")
  or
  property = "view" and
  call.getMethod()
      .getSourceDeclaration()
      .hasQualifiedName("org.springframework.web.servlet", "ModelAndView",
        ["setViewName", "setView"])
}

/** Gets the definite local allocation behind `value`, excluding ambiguous or merged values. */
private ClassInstanceExpr getViewAllocation(Expr value) { result = getLocalViewValue(value) }

/** Holds if an allocation can be changed outside the local, recognized property writes. */
private predicate viewEscapes(ClassInstanceExpr allocation, string property) {
  property = ["url", "view"] and
  (
    exists(Call call |
      DataFlow::localFlow(DataFlow::exprNode(allocation), DataFlow::exprNode(call.getAnArgument()))
    )
    or
    exists(MethodCall call |
      DataFlow::localFlow(DataFlow::exprNode(allocation), DataFlow::exprNode(call.getQualifier())) and
      not isSpringViewPropertyWrite(call, property)
    )
    or
    exists(AssignExpr assign |
      (assign.getDest() instanceof FieldAccess or assign.getDest() instanceof ArrayAccess) and
      DataFlow::localFlow(DataFlow::exprNode(allocation), DataFlow::exprNode(assign.getSource()))
    )
    or
    exists(ArrayInit init |
      DataFlow::localFlow(DataFlow::exprNode(allocation), DataFlow::exprNode(init.getAnInit()))
    )
    or
    exists(MemberRefExpr reference |
      DataFlow::localFlow(DataFlow::exprNode(allocation),
        DataFlow::exprNode(reference.getReceiverExpr()))
    )
    or
    exists(LocalScopeVariable variable, VarAccess access |
      access.getVariable() = variable and
      DataFlow::localFlow(DataFlow::exprNode(allocation), DataFlow::exprNode(access)) and
      variable.getAnAccess().getEnclosingCallable() != variable.getCallable()
    )
  )
}

/** Holds if a constant property replacement completes before this particular returned view. */
private predicate viewPropertyReplacedBeforeReturn(
  Call write, Expr value, ReturnStmt ret, string property
) {
  exists(ClassInstanceExpr allocation, MethodCall replacement |
    allocation = getViewAllocation(value) and
    allocation = getViewAllocation(ret.getExpr()) and
    not viewEscapes(allocation, property) and
    (
      property = "url" and
      allocation
          .getConstructedType()
          .hasQualifiedName("org.springframework.web.servlet.view", "RedirectView")
      or
      property = "view" and
      allocation
          .getConstructedType()
          .hasQualifiedName("org.springframework.web.servlet", "ModelAndView")
    ) and
    isSpringViewPropertyWrite(replacement, property) and
    exists(replacement.getArgument(0).(CompileTimeConstantExpr).getStringValue()) and
    getViewAllocation(replacement.getQualifier()) = allocation and
    not allocation.getParent*() instanceof LoopStmt and
    not replacement.getParent*() instanceof LoopStmt and
    not ret.getParent*() instanceof LoopStmt and
    strictlyDominates(write.getControlFlowNode(), replacement.getControlFlowNode()) and
    dominates(replacement.getControlFlowNode(), ret.getControlFlowNode()) and
    dominates(replacement.getControlFlowNode().getANormalSuccessor(), ret.getControlFlowNode()) and
    // A later or unordered write may replace the constant again. Possible aliases suffice here.
    not exists(MethodCall other |
      other != replacement and
      isSpringViewPropertyWrite(other, property) and
      DataFlow::localFlow(DataFlow::exprNode(allocation), DataFlow::exprNode(other.getQualifier())) and
      not strictlyDominates(other.getControlFlowNode(), replacement.getControlFlowNode())
    )
  )
}

/** Holds if `value` contributes to a view returned from a Spring MVC request handler. */
pragma[nomagic]
private predicate isSpringMvcViewResult(Expr value, Call write, string property) {
  property = ["url", "view"] and
  exists(ReturnStmt ret |
    ret.getEnclosingCallable() = value.getEnclosingCallable() and
    ret.getEnclosingCallable() instanceof SpringRequestMappingMethod and
    DataFlow::localFlow(DataFlow::exprNode(value), DataFlow::exprNode(ret.getExpr())) and
    not viewPropertyReplacedBeforeReturn(write, value, ret, property)
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
    isSpringMvcViewResult(newModelAndView, newModelAndView, "view")
  )
}

/** Holds if a name is constant or is constructed from the exact redirect prefix. */
private predicate isConstantOrRedirectViewName(Expr name) {
  exists(getLocalViewValue(name).(CompileTimeConstantExpr).getStringValue())
  or
  getViewNamePrefix(name) instanceof SpringRedirectPrefix
}

/** Holds if `callable` returns redirect names without mixing in other dynamic view names. */
pragma[nomagic]
private predicate returnsRedirectViewName(Callable callable) {
  exists(SpringRedirectPrefix prefix, DataFlow::ExprNode appended, ReturnStmt ret |
    callable.(Method).getReturnType() instanceof TypeString and
    forall(ReturnStmt r | r.getEnclosingCallable() = callable |
      isConstantOrRedirectViewName(r.getExpr())
    ) and
    ret.getEnclosingCallable() = callable and
    prefix = getViewNamePrefix(ret.getExpr()) and
    appendedToRedirectPrefix(prefix, appended) and
    TaintTracking::localTaint(appended, DataFlow::exprNode(ret.getExpr()))
  )
  or
  exists(MethodCall call, ReturnStmt ret |
    callable.(Method).getReturnType() instanceof TypeString and
    ret = unique(ReturnStmt r | r.getEnclosingCallable() = callable) and
    call = getViewNamePrefix(ret.getExpr()) and
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
      isSpringMvcViewResult(newRedirectView, newRedirectView, "url") and
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
      isSpringMvcViewResult(setUrl.getQualifier(), setUrl, "url") and
      this.asExpr() = setUrl.getArgument(0)
    )
  }
}

private class DefaultUrlRedirectSanitizer extends UrlRedirectSanitizer instanceof RequestForgerySanitizer
{ }
