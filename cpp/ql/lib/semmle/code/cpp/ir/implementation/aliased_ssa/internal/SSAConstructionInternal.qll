import semmle.code.cpp.ir.implementation.unaliased_ssa.IR as OldIR
import semmle.code.cpp.ir.implementation.unaliased_ssa.internal.reachability.ReachableBlock as Reachability
import semmle.code.cpp.ir.implementation.unaliased_ssa.internal.reachability.Dominance as Dominance
import semmle.code.cpp.ir.implementation.aliased_ssa.IR as NewIR
import semmle.code.cpp.ir.implementation.internal.TInstruction::AliasedSsaInstructions as SSAInstructions
import semmle.code.cpp.ir.internal.IRCppLanguage as Language
import AliasedSSA as Alias
import semmle.code.cpp.ir.implementation.internal.TOperand::AliasedSsaOperands as SSAOperands
private import SideEffectElimination as Elim

predicate removedInstruction(Reachability::ReachableInstruction instr) {
  Elim::removeableSideEffect(instr)
}

class OldBlock = Reachability::ReachableBlock;

class OldInstruction extends Reachability::ReachableInstruction {
  OldInstruction() { not Elim::removeableSideEffect(this) }
}
