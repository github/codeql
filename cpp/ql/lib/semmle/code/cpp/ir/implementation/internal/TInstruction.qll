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
    IRConstruction::Raw::InstructionTag1 tag1, IRConstruction::Raw::InstructionTag2 tag2
  ) {
    IRConstruction::Raw::hasInstruction(tag1, tag2)
  } or
  TRawUnreachedInstruction(IRFunctionBase irFunc) {
    IRConstruction::hasUnreachedInstruction(irFunc)
  } or
  TUnaliasedSsaPhiInstruction(
    TRawInstruction blockStartInstr, UnaliasedSsa::Ssa::MemoryLocation memoryLocation
  ) {
    UnaliasedSsa::Ssa::hasPhiInstruction(blockStartInstr, memoryLocation)
  } or
  TUnaliasedSsaChiInstruction(TRawInstruction primaryInstruction) { none() } or
  TUnaliasedSsaUnreachedInstruction(IRFunctionBase irFunc) {
    UnaliasedSsa::Ssa::hasUnreachedInstruction(irFunc)
  } or
  TUnaliasedSsaUninitializedGroupInstruction(UnaliasedSsa::Ssa::VariableGroup vg) or
  TAliasedSsaPhiInstruction(
    TRawInstruction blockStartInstr, AliasedSsa::Ssa::MemoryLocation memoryLocation
  ) {
    AliasedSsa::Ssa::hasPhiInstruction(blockStartInstr, memoryLocation)
  } or
  TAliasedSsaChiInstruction(TRawInstruction primaryInstruction) {
    AliasedSsa::Ssa::hasChiInstruction(primaryInstruction)
  } or
  TAliasedSsaUnreachedInstruction(IRFunctionBase irFunc) {
    AliasedSsa::Ssa::hasUnreachedInstruction(irFunc)
  } or
  TAliasedSsaUninitializedGroupInstruction(AliasedSsa::Ssa::VariableGroup vg) or
  TAliasedSsaChiAfterUninitializedGroupInstruction(
    TAliasedSsaUninitializedGroupInstruction initGroup
  ) {
    AliasedSsa::Ssa::hasChiNodeAfterUninitializedGroup(initGroup)
  }

/**
 * Provides wrappers for the constructors of each branch of `TInstruction` that is used by the
 * unaliased SSA stage.
 * These wrappers are not parameterized because it is not possible to invoke an IPA constructor via
 * a class alias.
 */
module UnaliasedSsaInstructions {
  class TPhiInstruction = TUnaliasedSsaPhiInstruction;

  TPhiInstruction phiInstruction(
    TRawInstruction blockStartInstr, UnaliasedSsa::Ssa::MemoryLocation memoryLocation
  ) {
    result = TUnaliasedSsaPhiInstruction(blockStartInstr, memoryLocation)
  }

  TRawInstruction reusedPhiInstruction(TRawInstruction blockStartInstr) { none() }

  class TChiInstruction = TUnaliasedSsaChiInstruction;

  class TUninitializedGroupInstruction = TUnaliasedSsaUninitializedGroupInstruction;

  class TRawOrUninitializedGroupInstruction = TRawInstruction or TUninitializedGroupInstruction;

  TChiInstruction chiInstruction(TRawOrUninitializedGroupInstruction primaryInstruction) {
    result = TUnaliasedSsaChiInstruction(primaryInstruction)
  }

  class TUnreachedInstruction = TUnaliasedSsaUnreachedInstruction;

  TUnreachedInstruction unreachedInstruction(IRFunctionBase irFunc) {
    result = TUnaliasedSsaUnreachedInstruction(irFunc)
  }

  class VariableGroup = UnaliasedSsa::Ssa::VariableGroup;

  // This really should just be `TUnaliasedSsaUninitializedGroupInstruction`, but that makes the
  // compiler realize that certain expressions in `SSAConstruction` are unsatisfiable.
  TRawOrUninitializedGroupInstruction uninitializedGroup(VariableGroup vg) { none() }
}

/**
 * Provides wrappers for the constructors of each branch of `TInstruction` that is used by the
 * aliased SSA stage.
 * These wrappers are not parameterized because it is not possible to invoke an IPA constructor via
 * a class alias.
 */
module AliasedSsaInstructions {
  class TPhiInstruction = TAliasedSsaPhiInstruction or TUnaliasedSsaPhiInstruction;

  TPhiInstruction phiInstruction(
    TRawInstruction blockStartInstr, AliasedSsa::Ssa::MemoryLocation memoryLocation
  ) {
    result = TAliasedSsaPhiInstruction(blockStartInstr, memoryLocation)
  }

  TPhiInstruction reusedPhiInstruction(TRawInstruction blockStartInstr) {
    result = TUnaliasedSsaPhiInstruction(blockStartInstr, _)
  }

  class TChiInstruction =
    TAliasedSsaChiInstruction or TAliasedSsaChiAfterUninitializedGroupInstruction;

  class TRawOrInitialzieGroupInstruction =
    TRawInstruction or TAliasedSsaUninitializedGroupInstruction;

  TChiInstruction chiInstruction(TRawOrInitialzieGroupInstruction primaryInstruction) {
    result = TAliasedSsaChiInstruction(primaryInstruction)
    or
    result = TAliasedSsaChiAfterUninitializedGroupInstruction(primaryInstruction)
  }

  class TUnreachedInstruction = TAliasedSsaUnreachedInstruction;

  TUnreachedInstruction unreachedInstruction(IRFunctionBase irFunc) {
    result = TAliasedSsaUnreachedInstruction(irFunc)
  }

  class VariableGroup = AliasedSsa::Ssa::VariableGroup;

  class TUninitializedGroupInstruction = TAliasedSsaUninitializedGroupInstruction;

  TUninitializedGroupInstruction uninitializedGroup(VariableGroup vg) {
    result = TAliasedSsaUninitializedGroupInstruction(vg)
  }
}
