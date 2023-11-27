private import cpp
private import semmle.code.cpp.commons.Scanf

private predicate exprInBooleanContext(Expr e) {
  e.getParent() instanceof BinaryLogicalOperation
  or
  e.getParent() instanceof UnaryLogicalOperation
  or
  e = any(IfStmt ifStmt).getCondition()
  or
  e = any(WhileStmt whileStmt).getCondition()
  or
  exists(EqualityOperation eqOp, Expr other |
    eqOp.hasOperands(e, other) and
    other.getValue() = "0"
  )
  or
  exists(Variable v |
    v.getAnAssignedValue() = e and
    forex(Expr use | use = v.getAnAccess() | exprInBooleanContext(use))
  )
}

private predicate isLinuxKernel() {
  // For the purpose of sscanf, we check the header guards for the files that it is defined in (which have changed)
  exists(Macro macro | macro.getName() in ["_LINUX_KERNEL_SPRINTF_H_", "_LINUX_KERNEL_H"])
}

/**
 * Holds if `call` is a `scanf`-like call were the result is only checked against 0, but it can also return EOF.
 */
predicate incorrectlyCheckedScanf(ScanfFunctionCall call) {
  exprInBooleanContext(call) and
  not isLinuxKernel() // scanf in the linux kernel can't return EOF
}
