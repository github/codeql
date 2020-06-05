private import TInstructionInternal
private import IRFunctionBase
private import TInstructionImports as Imports
private import Imports::IRType
private import Imports::Opcode

/**
 * An IR instruction. `TInstruction` is shared across all phases of the IR. There are individual
 * branches of this type for instructions created directly from the AST (`TRawInstruction`) and for
 * instructions added by each stage of SSA construction (`T*PhiInstruction`, `T*ChiInstruction`,
 * `T*UnreachedInstruction`). Each stage then defines a `TStageInstruction` type that is a union of
 * all of the branches that can appear in that particular stage. The public `Instruction` class for
 * each phase extends the `TStageInstruction` type for that stage.
 */
cached
newtype TInstruction =
  TRawInstruction(
    IRFunctionBase irFunc, Opcode opcode, Language::AST ast,
    IRConstruction::Raw::InstructionTag1 tag1, IRConstruction::Raw::InstructionTag2 tag2
  ) {
    IRConstruction::Raw::hasInstruction(irFunc.getFunction(), opcode, ast, tag1, tag2)
  } or
  TUnaliasedSSAPhiInstruction(
    IRFunctionBase irFunc, TRawInstruction blockStartInstr,
    UnaliasedSSA::SSA::MemoryLocation memoryLocation
  ) {
    UnaliasedSSA::SSA::hasPhiInstruction(irFunc, blockStartInstr, memoryLocation)
  } or
  TUnaliasedSSAChiInstruction(IRFunctionBase irFunc, TRawInstruction primaryInstruction) { none() } or
  TUnaliasedSSAUnreachedInstruction(IRFunctionBase irFunc) {
    UnaliasedSSA::SSA::hasUnreachedInstruction(irFunc)
  } or
  TAliasedSSAPhiInstruction(
    IRFunctionBase irFunc, TRawInstruction blockStartInstr,
    AliasedSSA::SSA::MemoryLocation memoryLocation
  ) {
    AliasedSSA::SSA::hasPhiInstruction(irFunc, blockStartInstr, memoryLocation)
  } or
  TAliasedSSAChiInstruction(IRFunctionBase irFunc, TRawInstruction primaryInstruction) {
    AliasedSSA::SSA::hasChiInstruction(irFunc, primaryInstruction)
  } or
  TAliasedSSAUnreachedInstruction(IRFunctionBase irFunc) {
    AliasedSSA::SSA::hasUnreachedInstruction(irFunc)
  }

/**
 * Provides wrappers for the constructors of each branch of `TInstruction` that is used by the
 * unaliased SSA stage.
 * These wrappers are not parameterized because it is not possible to invoke an IPA constructor via
 * a class alias.
 */
module UnaliasedSSAInstructions {
  class TPhiInstruction = TUnaliasedSSAPhiInstruction;

  TPhiInstruction phiInstruction(
    IRFunctionBase irFunc, TRawInstruction blockStartInstr,
    UnaliasedSSA::SSA::MemoryLocation memoryLocation
  ) {
    result = TUnaliasedSSAPhiInstruction(irFunc, blockStartInstr, memoryLocation)
  }

  class TChiInstruction = TUnaliasedSSAChiInstruction;

  TChiInstruction chiInstruction(IRFunctionBase irFunc, TRawInstruction primaryInstruction) {
    result = TUnaliasedSSAChiInstruction(irFunc, primaryInstruction)
  }

  class TUnreachedInstruction = TUnaliasedSSAUnreachedInstruction;

  TUnreachedInstruction unreachedInstruction(IRFunctionBase irFunc) {
    result = TUnaliasedSSAUnreachedInstruction(irFunc)
  }
}

/**
 * Provides wrappers for the constructors of each branch of `TInstruction` that is used by the
 * aliased SSA stage.
 * These wrappers are not parameterized because it is not possible to invoke an IPA constructor via
 * a class alias.
 */
module AliasedSSAInstructions {
  class TPhiInstruction = TAliasedSSAPhiInstruction;

  TPhiInstruction phiInstruction(
    IRFunctionBase irFunc, TRawInstruction blockStartInstr,
    AliasedSSA::SSA::MemoryLocation memoryLocation
  ) {
    result = TAliasedSSAPhiInstruction(irFunc, blockStartInstr, memoryLocation)
  }

  class TChiInstruction = TAliasedSSAChiInstruction;

  TChiInstruction chiInstruction(IRFunctionBase irFunc, TRawInstruction primaryInstruction) {
    result = TAliasedSSAChiInstruction(irFunc, primaryInstruction)
  }

  class TUnreachedInstruction = TAliasedSSAUnreachedInstruction;

  TUnreachedInstruction unreachedInstruction(IRFunctionBase irFunc) {
    result = TAliasedSSAUnreachedInstruction(irFunc)
  }
}
