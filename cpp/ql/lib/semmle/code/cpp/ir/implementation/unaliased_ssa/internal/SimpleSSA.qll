import AliasAnalysis
private import SimpleSSAImports
import SimpleSSAPublicImports
import AliasConfiguration
private import codeql.util.Unit

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

private newtype TMemoryLocation = MkMemoryLocation(Allocation var) { isVariableModeled(var) }

private MemoryLocation getMemoryLocation(Allocation var) { result.getAnAllocation() = var }

class MemoryLocation extends TMemoryLocation {
  Allocation var;

  MemoryLocation() { this = MkMemoryLocation(var) }

  final string toString() { result = var.getAllocationString() }

  final Allocation getAnAllocation() { result = var }

  final Language::Location getLocation() { result = var.getLocation() }

  final IRFunction getIRFunction() { result = var.getEnclosingIRFunction() }

  final VirtualVariable getVirtualVariable() { result = this }

  final Language::LanguageType getType() { result = var.getLanguageType() }

  final string getUniqueId() { result = var.getUniqueId() }

  final predicate canReuseSsa() { canReuseSsaForVariable(var) }
}

predicate canReuseSsaForOldResult(Instruction instr) { none() }

abstract class VariableGroup extends Unit {
  abstract Allocation getAnAllocation();

  string toString() { result = "{" + strictconcat(this.getAnAllocation().toString(), ", ") + "}" }

  abstract Language::Location getLocation();

  abstract IRFunction getIRFunction();

  abstract Language::LanguageType getType();

  abstract int getInitializationOrder();
}

class GroupedMemoryLocation extends MemoryLocation {
  VariableGroup vg;

  GroupedMemoryLocation() { none() }

  /** Gets an allocation of this memory location. */
  Allocation getAnAllocation() { result = vg.getAnAllocation() }

  /** Gets the set of allocations associated with this memory location. */
  VariableGroup getGroup() { result = vg }

  predicate isMayAccess() { none() }

  /** Holds if this memory location represents all the enclosing allocations. */
  predicate isAll() { none() }

  /** Holds if this memory location represents one or more of the enclosing allocations. */
  predicate isSome() { none() }
}

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
