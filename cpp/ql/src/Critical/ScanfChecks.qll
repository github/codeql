private import cpp
private import semmle.code.cpp.commons.Scanf
private import semmle.code.cpp.controlflow.IRGuards
private import semmle.code.cpp.ir.ValueNumbering

private predicate exprInBooleanContext(Expr e) {
  exists(IRGuardCondition gc |
    exists(Instruction i |
      i.getUnconvertedResultExpression() = e and
      gc.comparesEq(valueNumber(i).getAUse(), 0, _, _)
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
 * Gets the value of the EOF macro.
 *
 * This is typically `"-1"`, but this is not guaranteed to be the case on all
 * systems.
 */
private string getEofValue() {
  exists(MacroInvocation mi |
    mi.getMacroName() = "EOF" and
    result = unique( | | mi.getExpr().getValue())
  )
}

/**
 * Holds if the value of `call` has been checked to not equal `EOF`.
 */
private predicate checkedForEof(ScanfFunctionCall call) {
  exists(IRGuardCondition gc |
    exists(CallInstruction i | i.getUnconvertedResultExpression() = call |
      exists(int val | gc.comparesEq(valueNumber(i).getAUse(), val, _, _) |
        // call == EOF
        val = getEofValue().toInt()
        or
        // call == [any positive number]
        val > 0
      )
      or
      exists(int val | gc.comparesLt(valueNumber(i).getAUse(), val, true, _) |
        // call < [any non-negative number] (EOF is guaranteed to be negative)
        val >= 0
      )
    )
  )
}

/**
 * Holds if `call` is a `scanf`-like call were the result is only checked against 0, but it can also return EOF.
 */
predicate incorrectlyCheckedScanf(ScanfFunctionCall call) {
  exprInBooleanContext(call) and
  not checkedForEof(call) and
  not isLinuxKernel() // scanf in the linux kernel can't return EOF
}
