import AliasAnalysis
private import SimpleSSAImports
import SimpleSSAPublicImports
private import AliasConfiguration

private predicate isTotalAccess(Allocation var, AddressOperand addrOperand, IRType type) {
  exists(Instruction constantBase, int bitOffset |
    addressOperandBaseAndConstantOffset(addrOperand, constantBase, bitOffset) and
    bitOffset = 0 and
    constantBase = var.getABaseInstruction() and
    type = var.getIRType()
  )
}

/**
 * Holds if the specified variable should be modeled in SSA form. For unaliased SSA, we only model a
 * variable if its address never escapes and all reads and writes of that variable access the entire
 * variable using the original type of the variable.
 */
predicate isVariableModeled(Allocation var) {
  not allocationEscapes(var) and
  forall(Instruction instr, AddressOperand addrOperand, IRType type |
    addrOperand = instr.getResultAddressOperand() and
    type = instr.getResultIRType() and
    var = getAddressOperandAllocation(addrOperand)
  |
    isTotalAccess(var, addrOperand, type) and not instr.hasResultMayMemoryAccess()
  ) and
  forall(MemoryOperand memOperand, AddressOperand addrOperand, IRType type |
    addrOperand = memOperand.getAddressOperand() and
    type = memOperand.getIRType() and
    var = getAddressOperandAllocation(addrOperand)
  |
    isTotalAccess(var, addrOperand, type) and not memOperand.hasMayReadMemoryAccess()
  )
}

/**
 * Holds if the SSA use/def chain for the specified variable can be safely reused by later
 * iterations of SSA construction. This will hold only if we modeled the variable soundly, so that
 * subsequent iterations will recompute SSA for any variable that we assumed did not escape, but
 * actually would have escaped if we had used a sound escape analysis.
 */
predicate canReuseSsaForVariable(IRAutomaticVariable var) {
  isVariableModeled(var) and
  not allocationEscapes(var)
}

/** DEPRECATED: Alias for canReuseSsaForVariable */
deprecated predicate canReuseSSAForVariable = canReuseSsaForVariable/1;

private newtype TMemoryLocation = MkMemoryLocation(Allocation var) { isVariableModeled(var) }

private MemoryLocation getMemoryLocation(Allocation var) { result.getAllocation() = var }

class MemoryLocation extends TMemoryLocation {
  Allocation var;

  MemoryLocation() { this = MkMemoryLocation(var) }

  final string toString() { result = var.getAllocationString() }

  final Allocation getAllocation() { result = var }

  final Language::Location getLocation() { result = var.getLocation() }

  final IRFunction getIRFunction() { result = var.getEnclosingIRFunction() }

  final VirtualVariable getVirtualVariable() { result = this }

  final Language::LanguageType getType() { result = var.getLanguageType() }

  final string getUniqueId() { result = var.getUniqueId() }

  final predicate canReuseSsa() { canReuseSsaForVariable(var) }

  /** DEPRECATED: Alias for canReuseSsa */
  deprecated predicate canReuseSSA() { canReuseSsa() }
}

predicate canReuseSsaForOldResult(Instruction instr) { none() }

/** DEPRECATED: Alias for canReuseSsaForOldResult */
deprecated predicate canReuseSSAForOldResult = canReuseSsaForOldResult/1;

/**
 * Represents a set of `MemoryLocation`s that cannot overlap with
 * `MemoryLocation`s outside of the set. The `VirtualVariable` will be
 * represented by a `MemoryLocation` that totally overlaps all other
 * `MemoryLocations` in the set.
 */
class VirtualVariable extends MemoryLocation { }

/** A virtual variable that groups all escaped memory within a function. */
class AliasedVirtualVariable extends VirtualVariable {
  AliasedVirtualVariable() { none() }
}

Overlap getOverlap(MemoryLocation def, MemoryLocation use) {
  def = use and result instanceof MustExactlyOverlap
  or
  none() // Avoid compiler error in SSAConstruction
}

MemoryLocation getResultMemoryLocation(Instruction instr) {
  result = getMemoryLocation(getAddressOperandAllocation(instr.getResultAddressOperand()))
}

MemoryLocation getOperandMemoryLocation(MemoryOperand operand) {
  result = getMemoryLocation(getAddressOperandAllocation(operand.getAddressOperand()))
}

/** Gets the start bit offset of a `MemoryLocation`, if any. */
int getStartBitOffset(MemoryLocation location) { none() }

/** Gets the end bit offset of a `MemoryLocation`, if any. */
int getEndBitOffset(MemoryLocation location) { none() }
