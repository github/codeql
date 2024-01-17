private import cpp
private import semmle.code.cpp.commons.Scanf
private import semmle.code.cpp.controlflow.IRGuards
private import semmle.code.cpp.ir.ValueNumbering

private predicate exprInBooleanContext(Expr e) {
  exists(IRGuardCondition gc |
    exists(Instruction i, ConstantInstruction zero |
      zero.getValue() = "0" and
      i.getUnconvertedResultExpression() = e and
      gc.comparesEq(valueNumber(i).getAUse(), zero.getAUse(), 0, _, _)
    )
    or
    gc.getUnconvertedResultExpression() = e
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
