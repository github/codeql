import default
import semmle.code.cpp.ir.implementation.unaliased_ssa.internal.AliasAnalysis
import semmle.code.cpp.ir.implementation.raw.IR

predicate shouldEscape(IRAutomaticUserVariable var) {
  exists(string name |
    name = var.getVariable().getName() and
    name.matches("no_%") and
    not name.matches("no_ssa_%")
  )
}

from IRAutomaticUserVariable var
where
  exists(IRFunction irFunc |
    irFunc = var.getEnclosingIRFunction() and
    (
      shouldEscape(var) and variableAddressEscapes(var)
      or
      not shouldEscape(var) and not variableAddressEscapes(var)
    )
  )
select var
