import default
import semmle.code.cpp.ir.implementation.aliased_ssa.internal.AliasAnalysis
import semmle.code.cpp.ir.implementation.aliased_ssa.internal.AliasConfiguration
import semmle.code.cpp.ir.implementation.unaliased_ssa.IR

predicate shouldEscape(IRAutomaticUserVariable var) {
  exists(string name |
    name = var.getVariable().getName() and
    name.matches("no_%")
  )
}

from IRAutomaticUserVariable var
where
  exists(VariableAddressInstruction instr, Allocation allocation |
    instr.getVariable() = var and
    allocation.getAnInstruction() = instr and
    (
      (shouldEscape(var) and allocationEscapes(allocation)) or
      (not shouldEscape(var) and not allocationEscapes(allocation))
    )
  )
select var
