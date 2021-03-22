private import TInstruction
private import OperandTag
private import semmle.code.cpp.ir.implementation.raw.internal.IRConstruction as RawConstruction
private import semmle.code.cpp.ir.implementation.unaliased_ssa.internal.SSAConstruction as UnaliasedConstruction
private import semmle.code.cpp.ir.implementation.aliased_ssa.internal.SSAConstruction as AliasedConstruction
private import semmle.code.cpp.ir.implementation.raw.IR as Raw
private import semmle.code.cpp.ir.implementation.unaliased_ssa.IR as Unaliased
private import semmle.code.cpp.ir.implementation.aliased_ssa.IR as Aliased
private import semmle.code.cpp.ir.internal.Overlap

/**
 * Provides the newtype used to represent operands across all phases of the IR.
 */
private module Internal {
  /**
   * An IR operand. `TOperand` is shared across all phases of the IR. There are branches of this
   * type for operands created directly from the AST (`TRegisterOperand` and `TNonSSAMemoryOperand`),
   * for operands computed by each stage of SSA construction (`T*PhiOperand` and
   * `TAliasedChiOperand`), and a placehold branch for operands that do not exist in a given
   * stage of IR construction (`TNoOperand`).
   */
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
    // Until we share SSA, these will be all the phis there are. With SSA
    // sharing, these will add to the ones that are already there.
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
    TAliasedChiOperand(TAliasedSSAChiInstruction useInstr, ChiOperandTag tag) { any() }
}

/**
 * Reexports some branches from `TOperand` so they can be used in stage modules without importing
 * `TOperand` itself.
 */
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

/**
 * Provides wrappers for the constructors of each branch of `TOperand` that is used by the
 * raw IR stage.
 * These wrappers are not parameterized because it is not possible to invoke an IPA constructor via
 * a class alias.
 */
module RawOperands {
  import Shared

  class TPhiOperand = Internal::TNoOperand;

  class TChiOperand = Internal::TNoOperand;

  class TNonPhiMemoryOperand = TNonSSAMemoryOperand or TChiOperand;

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

/**
 * Provides wrappers for the constructors of each branch of `TOperand` that is used by the
 * unaliased SSA stage.
 * These wrappers are not parameterized because it is not possible to invoke an IPA constructor via
 * a class alias.
 */
module UnaliasedSSAOperands {
  import Shared

  class TPhiOperand = Internal::TUnaliasedPhiOperand;

  class TChiOperand = Internal::TNoOperand;

  class TNonPhiMemoryOperand = TNonSSAMemoryOperand or TChiOperand;

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

/**
 * Provides wrappers for the constructors of each branch of `TOperand` that is used by the
 * asliased SSA stage.
 * These wrappers are not parameterized because it is not possible to invoke an IPA constructor via
 * a class alias.
 */
module AliasedSSAOperands {
  import Shared

  class TPhiOperand = Internal::TAliasedPhiOperand;

  class TChiOperand = Internal::TAliasedChiOperand;

  class TNonPhiMemoryOperand = TNonSSAMemoryOperand or TChiOperand;

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
