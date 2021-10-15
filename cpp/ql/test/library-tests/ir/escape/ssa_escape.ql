import cpp
import semmle.code.cpp.ir.implementation.aliased_ssa.internal.AliasAnalysis
import semmle.code.cpp.ir.implementation.aliased_ssa.internal.AliasConfiguration
import semmle.code.cpp.ir.implementation.unaliased_ssa.IR
import semmle.code.cpp.ir.implementation.UseSoundEscapeAnalysis

class InterestingAllocation extends VariableAllocation {
  IRUserVariable userVar;

  InterestingAllocation() { userVar = this.getIRVariable() }

  final predicate shouldEscape() { userVar.getVariable().getName().matches("no_%") }
}

from InterestingAllocation var
where
  exists(IRFunction irFunc |
    irFunc = var.getEnclosingIRFunction() and
    (
      var.shouldEscape() and allocationEscapes(var)
      or
      not var.shouldEscape() and not allocationEscapes(var)
    )
  )
select var
