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
newtype TInstruction =
  TRawInstruction(
    IRFunctionBase irFunc, Opcode opcode, Language::AST ast, Language::LanguageType resultType,
    IRConstruction::Raw::InstructionTag1 tag1, IRConstruction::Raw::InstructionTag2 tag2
  ) {
    IRConstruction::Raw::hasInstruction(irFunc.getFunction(), opcode, ast, resultType, tag1, tag2)
  } or
  TUnaliasedSSAPhiInstruction(
    IRFunctionBase irFunc, Language::LanguageType resultType, TRawInstruction blockStartInstr,
    UnaliasedSSA::SSA::MemoryLocation memoryLocation
  ) {
    UnaliasedSSA::SSA::hasPhiInstruction(irFunc, resultType, blockStartInstr, memoryLocation)
  } or
  TUnaliasedSSAChiInstruction(
    IRFunctionBase irFunc, Language::LanguageType resultType, TRawInstruction primaryInstruction
  ) {
    none()
  } or
  TUnaliasedSSAUnreachedInstruction(IRFunctionBase irFunc) {
    UnaliasedSSA::SSA::hasUnreachedInstruction(irFunc)
  } or
  TAliasedSSAPhiInstruction(
    IRFunctionBase irFunc, Language::LanguageType resultType, TRawInstruction blockStartInstr,
    AliasedSSA::SSA::MemoryLocation memoryLocation
  ) {
    AliasedSSA::SSA::hasPhiInstruction(irFunc, resultType, blockStartInstr, memoryLocation)
  } or
  TAliasedSSAChiInstruction(
    IRFunctionBase irFunc, Language::LanguageType resultType, TRawInstruction primaryInstruction
  ) {
    AliasedSSA::SSA::hasChiInstruction(irFunc, resultType, primaryInstruction)
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
    IRFunctionBase irFunc, Language::LanguageType resultType, TRawInstruction blockStartInstr,
    UnaliasedSSA::SSA::MemoryLocation memoryLocation
  ) {
    result = TUnaliasedSSAPhiInstruction(irFunc, resultType, blockStartInstr, memoryLocation)
  }

  class TChiInstruction = TUnaliasedSSAChiInstruction;

  TChiInstruction chiInstruction(
    IRFunctionBase irFunc, Language::LanguageType resultType, TRawInstruction primaryInstruction
  ) {
    result = TUnaliasedSSAChiInstruction(irFunc, resultType, primaryInstruction)
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
    IRFunctionBase irFunc, Language::LanguageType resultType, TRawInstruction blockStartInstr,
    AliasedSSA::SSA::MemoryLocation memoryLocation
  ) {
    result = TAliasedSSAPhiInstruction(irFunc, resultType, blockStartInstr, memoryLocation)
  }

  class TChiInstruction = TAliasedSSAChiInstruction;

  TChiInstruction chiInstruction(
    IRFunctionBase irFunc, Language::LanguageType resultType, TRawInstruction primaryInstruction
  ) {
    result = TAliasedSSAChiInstruction(irFunc, resultType, primaryInstruction)
  }

  class TUnreachedInstruction = TAliasedSSAUnreachedInstruction;

  TUnreachedInstruction unreachedInstruction(IRFunctionBase irFunc) {
    result = TAliasedSSAUnreachedInstruction(irFunc)
  }
}
