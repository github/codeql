/** Provides definitions related to `java.io.InputStream`. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.dataflow.TaintTracking

/**
 * A jump taint step from an update of the `bytes[]` parameter in an override of the `InputStream.read` method
 * to a class instance expression of the type extending `InputStream`.
 *
 * This models how a subtype of `InputStream` could be tainted by the definition of its methods, which will
 * normally only happen in nested classes.
 */
private class InputStreamWrapperCapturedJumpStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(InputStreamRead m, NestedClass wrapper |
      m.getDeclaringType() = wrapper and
      wrapper.getASourceSupertype+() instanceof TypeInputStream
    |
      n1.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = m.getParameter(0).getAnAccess() and
      n2.asExpr()
          .(ClassInstanceExpr)
          .getConstructedType()
          .getASourceSupertype*()
          .getSourceDeclaration() = wrapper
    )
  }
}

/**
 * A local taint step from the definition of a captured variable, the capturer of which
 * updates the `bytes[]` parameter in an override of the `InputStream.read` method,
 * to a class instance expression of the type extending `InputStream`.
 *
 * This models how a subtype of `InputStream` could be tainted by capturing tainted variables in
 * the definition of its methods.
 */
private class InputStreamWrapperCapturedLocalStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(InputStreamRead m, NestedClass wrapper, SsaVariable captured, SsaImplicitInit capturer |
      wrapper.getASourceSupertype+() instanceof TypeInputStream and
      m.getDeclaringType() = wrapper and
      capturer.captures(captured) and
      TaintTracking::localTaint(DataFlow::exprNode(capturer.getAFirstUse()),
        any(DataFlow::PostUpdateNode pun |
          pun.getPreUpdateNode().asExpr() = m.getParameter(0).getAnAccess()
        )) and
      n2.asExpr()
          .(ClassInstanceExpr)
          .getConstructedType()
          .getASourceSupertype*()
          .getSourceDeclaration() = wrapper
    |
      n1.asExpr() = captured.(SsaExplicitUpdate).getDefiningExpr().(VariableAssign).getSource()
      or
      captured.(SsaImplicitInit).isParameterDefinition(n1.asParameter())
    )
  }
}

/**
 * A taint step from an `InputStream` argument of the constructor of an `InputStream` subtype
 * to the call of the constructor, only if the argument is assigned to a class field.
 *
 * This models how it's assumed that an `InputStream` wrapper is tainted by the wrapped stream,
 * and is a workaround to low `fieldFlowBranchLimit`s in dataflow configurations.
 */
private class InputStreamWrapperConstructorStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(ClassInstanceExpr cc, Argument a, AssignExpr ae, int pos |
      cc.getConstructedType().getASourceSupertype+() instanceof TypeInputStream and
      cc.getArgument(pragma[only_bind_into](pos)) = a and
      cc.getCallee().getParameter(pragma[only_bind_into](pos)).getAnAccess() = ae.getRhs() and
      ae.getDest().(FieldWrite).getField().getType().(RefType).getASourceSupertype*() instanceof
        TypeInputStream
    |
      n1.asExpr() = a and
      n2.asExpr() = cc
    )
  }
}

private class InputStreamRead extends Method {
  InputStreamRead() {
    this.hasName("read") and
    this.getDeclaringType().getASourceSupertype*() instanceof TypeInputStream
  }
}
