import semmle.code.java.Expr
import semmle.code.java.dataflow.SSA
import semmle.code.java.controlflow.Guards

/** Holds if the method `method` validates its `arg`-th argument in some way. */
predicate validationMethod(Method method, int arg) {
  // The method examines the contents of the string argument.
  exists(Parameter param, VarAccess paramRef, MethodCall call |
    method.getParameter(arg) = param and
    param.getType() instanceof TypeString and
    paramRef.getVariable() = param and
    call.getQualifier() = paramRef and
    (
      call.getMethod().getName() = "contains" or
      call.getMethod().getName() = "charAt"
    )
  )
  or
  // The method calls another one that verifies the argument.
  exists(Parameter param, MethodCall call, int recursiveArg |
    method.getParameter(arg) = param and
    call.getArgument(pragma[only_bind_into](recursiveArg)) = param.getAnAccess() and
    validationMethod(pragma[only_bind_into](call.getMethod()), pragma[only_bind_into](recursiveArg))
  )
}

private predicate validationCall(MethodCall ma, VarAccess va) {
  exists(int arg | validationMethod(ma.getMethod(), arg) and ma.getArgument(arg) = va)
}

private predicate validatedAccess(VarAccess va) {
  exists(SsaVariable v, MethodCall guardcall |
    va = v.getAUse() and
    validationCall(guardcall, v.getAUse())
  |
    guardcall.(Guard).controls(va.getBasicBlock(), _)
    or
    exists(ControlFlowNode node |
      guardcall.getMethod().getReturnType() instanceof VoidType and
      guardcall.getControlFlowNode() = node
    |
      exists(BasicBlock succ |
        succ = node.getANormalSuccessor() and
        dominatingEdge(node.getBasicBlock(), succ) and
        succ.bbDominates(va.getBasicBlock())
      )
      or
      exists(BasicBlock bb, int i |
        bb.getNode(i) = node and
        bb.getNode(i + 1) = node.getANormalSuccessor()
      |
        bb.bbStrictlyDominates(va.getBasicBlock()) or
        bb.getNode(any(int j | j > i)).asExpr() = va
      )
    )
  )
}

/** A variable access that is guarded by a string verification method. */
class ValidatedVariableAccess extends VarAccess {
  ValidatedVariableAccess() { validatedAccess(this) }
}
