import default
import semmle.code.cpp.ssa.internal.aliased_ssa.AliasAnalysis
import semmle.code.cpp.ssa.SSAIR

predicate shouldEscape(IRAutomaticUserVariable var) {
  exists(string name |
    name = var.getVariable().getName() and
    name.matches("no_%")
  )
}

from IRAutomaticUserVariable var
where
  exists(FunctionIR funcIR |
    funcIR = var.getFunctionIR() and
    (
      (shouldEscape(var) and variableAddressEscapes(var)) or
      (not shouldEscape(var) and not variableAddressEscapes(var))
    )
  )
select var
