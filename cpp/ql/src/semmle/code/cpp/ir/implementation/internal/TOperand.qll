private import TInstruction
private import OperandTag
private import semmle.code.cpp.ir.implementation.raw.internal.IRConstruction as RawConstruction
private import semmle.code.cpp.ir.implementation.unaliased_ssa.internal.SSAConstruction as UnaliasedConstruction
private import semmle.code.cpp.ir.implementation.aliased_ssa.internal.SSAConstruction as AliasedConstruction
private import semmle.code.cpp.ir.implementation.raw.IR as Raw
private import semmle.code.cpp.ir.implementation.unaliased_ssa.IR as Unaliased
private import semmle.code.cpp.ir.implementation.aliased_ssa.IR as Aliased
private import semmle.code.cpp.ir.internal.Overlap

private module Internal {
  cached
  newtype TOperand =
    // RAW
    TRegisterOperand(TRawInstruction useInstr, RegisterOperandTag tag, TRawInstruction defInstr) {
      defInstr = RawConstruction::getRegisterOperandDefinition(useInstr, tag) and
      not RawConstruction::isInCycle(useInstr) and
      strictcount(RawConstruction::getRegisterOperandDefinition(useInstr, tag)) = 1
    } or
    // Placeholder for Phi and Chi operands in stages that don't have the corresponding instructions
    TNoOperand() { none() } or
    // Can be "removed" later when there's unreachable code
    // These operands can be reused across all three stages. They just get different defs.
    TNonSSAMemoryOperand(Raw::Instruction useInstr, MemoryOperandTag tag) {
      // Has no definition in raw but will get definitions later
      useInstr.getOpcode().hasOperand(tag)
    } or
    TUnaliasedPhiOperand(
      Unaliased::PhiInstruction useInstr, Unaliased::Instruction defInstr,
      Unaliased::IRBlock predecessorBlock, Overlap overlap
    ) {
      defInstr = UnaliasedConstruction::getPhiOperandDefinition(useInstr, predecessorBlock, overlap)
    } or
    //// ALIASED
    ////
    // If we share SSA, these will be all the phis there are. Otherwise these
    // will add to the ones that are already there.
    // If we share SSA, be careful with the case where we remove all possible
    // indirect writes to a variable because they're dead code. In that case it's
    // important that we use the same definition of "is variable aliased" across
    // the phases.
    TAliasedPhiOperand(
      TAliasedSSAPhiInstruction useInstr, Aliased::Instruction defInstr,
      Aliased::IRBlock predecessorBlock, Overlap overlap
    ) {
      defInstr = AliasedConstruction::getPhiOperandDefinition(useInstr, predecessorBlock, overlap)
    } or
    TAliasedChiOperand(TAliasedSSAChiInstruction useInstr, ChiOperandTag tag) {
      // TODO: any further restrictions here?
      any()
    }
}

private module Shared {
  class TRegisterOperand = Internal::TRegisterOperand;

  /**
   * Returns the register operand with the specified parameters.
   */
  TRegisterOperand registerOperand(
    TRawInstruction useInstr, RegisterOperandTag tag, TRawInstruction defInstr
  ) {
    result = Internal::TRegisterOperand(useInstr, tag, defInstr)
  }

  class TNonSSAMemoryOperand = Internal::TNonSSAMemoryOperand;

  /**
   * Returns the non-Phi memory operand with the specified parameters.
   */
  TNonSSAMemoryOperand nonSSAMemoryOperand(TRawInstruction useInstr, MemoryOperandTag tag) {
    result = Internal::TNonSSAMemoryOperand(useInstr, tag)
  }
}

module RawOperands {
  import Shared

  class TPhiOperand = Internal::TNoOperand;

  class TChiOperand = Internal::TNoOperand;

  /**
   * Returns the Phi operand with the specified parameters.
   */
  TPhiOperand phiOperand(
    Raw::PhiInstruction useInstr, Raw::Instruction defInstr, Raw::IRBlock predecessorBlock,
    Overlap overlap
  ) {
    none()
  }

  /**
   * Returns the Chi operand with the specified parameters.
   */
  TChiOperand chiOperand(Raw::Instruction useInstr, ChiOperandTag tag) { none() }
}

// TODO: can we get everything into either here or Operand.qll?
// TODO: can we put `TStageOperand` in Construction? Might break something about the module caching setup, `Operand` is currently after everything in SSAConstruction
// TODO: share empty ChiOperand?
module UnliasedSSAOperands {
  import Shared

  class TPhiOperand = Internal::TUnaliasedPhiOperand;

  class TChiOperand = Internal::TNoOperand;

  /**
   * Returns the Phi operand with the specified parameters.
   */
  TPhiOperand phiOperand(
    Unaliased::PhiInstruction useInstr, Unaliased::Instruction defInstr,
    Unaliased::IRBlock predecessorBlock, Overlap overlap
  ) {
    result = Internal::TUnaliasedPhiOperand(useInstr, defInstr, predecessorBlock, overlap)
  }

  /**
   * Returns the Chi operand with the specified parameters.
   */
  TChiOperand chiOperand(Unaliased::Instruction useInstr, ChiOperandTag tag) { none() }
}

module AliasedSSAOperands {
  import Shared

  class TPhiOperand = Internal::TAliasedPhiOperand;

  class TChiOperand = Internal::TAliasedChiOperand;

  /**
   * Returns the Phi operand with the specified parameters.
   */
  TPhiOperand phiOperand(
    TAliasedSSAPhiInstruction useInstr, Aliased::Instruction defInstr,
    Aliased::IRBlock predecessorBlock, Overlap overlap
  ) {
    result = Internal::TAliasedPhiOperand(useInstr, defInstr, predecessorBlock, overlap)
  }

  /**
   * Returns the Chi operand with the specified parameters.
   */
  TChiOperand chiOperand(TAliasedSSAChiInstruction useInstr, ChiOperandTag tag) {
    result = Internal::TAliasedChiOperand(useInstr, tag)
  }
}
