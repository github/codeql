private import cpp
import AliasAnalysis
import semmle.code.cpp.ir.internal.Overlap
private import AliasConfiguration
private import semmle.code.cpp.Print
private import semmle.code.cpp.ir.implementation.unaliased_ssa.IR
private import semmle.code.cpp.ir.internal.IntegerConstant as Ints
private import semmle.code.cpp.ir.internal.IntegerInterval as Interval
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import semmle.code.cpp.ir.implementation.unaliased_ssa.gvn.ValueNumbering

private class IntValue = Ints::IntValue;

/**
 * Gets a printable string for the specified base address.
 */
private string getBaseAddressString(ValueNumber baseAddress) {
  // If it's the value of a parameter, just use the parameter name.
  result = baseAddress.getAnInstruction().(InitializeParameterInstruction).getParameter().toString() or
  (
    // Otherwise, use the `toString()` of the example instruction.
    not exists(baseAddress.getAnInstruction().(InitializeParameterInstruction)) and
    result = baseAddress.getExampleInstruction().toString()
  )
}

/**
 * Holds if the indirect memory access via `addrOperand` has the specified type and size (in bytes).
 */
private predicate memoryAccessTypeAndSize(AddressOperand addrOperand, Type type,
    IntValue byteSize) {
  exists(Instruction instr |
    instr = addrOperand.getUse() and
    instr.getResultAddressOperand() = addrOperand and
    type = instr.getResultType() and
    (
      byteSize = instr.getResultSize() or
      not exists(instr.getResultSize()) and byteSize = Ints::unknown()
    )
  ) or
  exists(MemoryOperand operand |
    operand.getAddressOperand() = addrOperand and
    type = operand.getType() and
    (
      byteSize = operand.getSize() or
      not exists(operand.getSize()) and byteSize = Ints::unknown()
    )
  )
}

/**
 * Holds if the indirect memory access via `addrOperand` has the specified type, base address, and
 * offset interval.
 */
private predicate hasMemoryAccess(AddressOperand addrOperand, Type type, ValueNumber baseAddress,
    IntValue startBitOffset, IntValue endBitOffset) {
  exists(Instruction baseInstr, IntValue byteSize |
    addressOperandBaseAndConstantOffset(addrOperand, baseInstr, startBitOffset) and
    memoryAccessTypeAndSize(addrOperand, type, byteSize) and
    endBitOffset = Ints::add(startBitOffset, Ints::mul(byteSize, 8)) and
    baseAddress = valueNumber(baseInstr)
  )
}

private newtype TMemoryLocation =
  TIndirectMemoryLocation(Type type, ValueNumber baseAddress, IntValue startBitOffset,
      IntValue endBitOffset) {
    hasMemoryAccess(_, type, baseAddress, startBitOffset, endBitOffset)
  }
  or
  TUnknownMemoryLocation(IRFunction irFunc) or
  TUnknownVirtualVariable(IRFunction irFunc)

/**
 * Represents the memory location accessed by a memory operand or memory result. In this
 * implementation, the location is one of the following:
 * - `IndirectMemoryLocation` - A location at a constant offset from a known base address.
 * - `UnknownMemoryLocation` - A location in aliased memory, without a specific address.
 */
abstract class MemoryLocation extends TMemoryLocation {
  abstract string toString();
  
  abstract VirtualVariable getVirtualVariable();

  abstract Type getType();

  abstract Allocation getAllocation();

  abstract string getUniqueId();
}

abstract class VirtualVariable extends MemoryLocation {
}

/**
 * An access to memory at a constant offset from a known base address. The address may or may not be
 * in a known allocation.
 */
class IndirectMemoryLocation extends TIndirectMemoryLocation, MemoryLocation {
  ValueNumber baseAddress;
  Type type;
  IntValue startBitOffset;
  IntValue endBitOffset;

  IndirectMemoryLocation() {
    this = TIndirectMemoryLocation(type, baseAddress, startBitOffset, endBitOffset)
  }

  private string getAllocationString() {
    result = getAllocation().getAllocationString() or
    not exists(getAllocation()) and result = "??"
  }

  private string getBaseAddressStringIfNeeded() {
    if getAllocation() = baseAddress then
      result = ""
    else
      result = "@'" + getBaseAddressString(baseAddress) + "'+"
  }

  private string getIntervalString() {
    if coversEntireVariable() then
      result = ""
    else
      result = Interval::getIntervalString(startBitOffset, endBitOffset)
  }

  private string getTypeString() {
    if coversEntireVariable() and type = getAllocation().getType() then
      result = ""
    else
      result = "<" + type.toString() + ">"
  }

  override final string toString() {
    result = getAllocationString() + getBaseAddressStringIfNeeded() + getIntervalString() +
      getTypeString()
  }

  override final Type getType() {
    result = type
  }

  /**
   * Gets the bit offset from the base address at which the access starts.
   */
  final IntValue getStartBitOffset() {
    result = startBitOffset
  }
  
  /**
   * Gets the bit offset from the base address at which the access ends. This offset is one bit past
   * the last bit actually accessed.
   */
  final IntValue getEndBitOffset() {
    result = endBitOffset
  }
  
  /**
   * Gets the base address to which the offsets are relative.
   */
  final ValueNumber getBaseAddress() {
    result = baseAddress
  }

  override Allocation getAllocation() {
    exists(AddressOperand addrOperand |
      this = getMemoryLocation(addrOperand) and
      result = getAddressOperandAllocation(addrOperand)
    )
  }

  override final string getUniqueId() {
    result = baseAddress.getExampleInstruction().getUniqueId() +
      Interval::getIntervalString(startBitOffset, endBitOffset) + "<" +
      getTypeIdentityString(type) + ">"
  }

  override final VirtualVariable getVirtualVariable() {
    exists(Allocation allocation |
      // In an unaliased allocation, get the memory access for the entire allocation.
      allocation = getAllocation() and
      allocation.isUnaliased() and
      result = TIndirectMemoryLocation(allocation.getType(), allocation, 0,
        allocation.getBitSize())
    ) or
    (
      // All aliased allocations are grouped into the `UnknownVirtualVariable`.
      not getAllocation().isUnaliased() and
      result = TUnknownVirtualVariable(baseAddress.getAnInstruction().getEnclosingIRFunction())
    )
  }

  /**
   * Holds if this memory location covers the entire variable.
   */
  final predicate coversEntireVariable() {
    startBitOffset = 0 and
    endBitOffset = getAllocation().getBitSize()
  }
}

/**
 * Represents the `MemoryLocation` for an entire unaliased allocation. This is also the
 * `IndirectMemoryLocation` for accesses that directly read or write the whole allocation with the
 * correct type.
 */
class UnaliasedVirtualVariable extends IndirectMemoryLocation, VirtualVariable {
  UnaliasedVirtualVariable() {
    exists(Allocation allocation |
      allocation = getAllocation() and
      allocation.isUnaliased() and
      type = allocation.getType() and
      coversEntireVariable()
    )
  }
}

/**
 * An access to memory that is not known to be confined to a specific allocation.
 */
class UnknownMemoryLocation extends TUnknownMemoryLocation, MemoryLocation {
  IRFunction irFunc;

  UnknownMemoryLocation() {
    this = TUnknownMemoryLocation(irFunc)
  }
  
  override final string toString() {
    result = "{Unknown}"
  }
  
  override final VirtualVariable getVirtualVariable() {
    result = TUnknownVirtualVariable(irFunc)
  }

  override final Type getType() {
    result instanceof UnknownType
  }

  override final Allocation getAllocation() {
    none()
  }

  override final string getUniqueId() {
    result = "{Unknown}"
  }
}

/**
 * An access to all aliased memory.
 */
class UnknownVirtualVariable extends TUnknownVirtualVariable, VirtualVariable {
  IRFunction irFunc;

  UnknownVirtualVariable() {
    this = TUnknownVirtualVariable(irFunc)
  }
  
  override final string toString() {
    result = "{AllAliased}"
  }

  override final Type getType() {
    result instanceof UnknownType
  }

  override final Allocation getAllocation() {
    none()
  }

  override final string getUniqueId() {
    result = " " + toString()
  }

  override final VirtualVariable getVirtualVariable() {
    result = this
  }
}

Overlap getOverlap(MemoryLocation def, MemoryLocation use) {
  // The def and the use must have the same virtual variable, or no overlap is possible.
  (
    // An UnknownVirtualVariable must totally overlap any location within the same virtual variable.
    def.getVirtualVariable() = use.getVirtualVariable() and
    def instanceof UnknownVirtualVariable and result instanceof MustTotallyOverlap
    or
    // An UnknownMemoryLocation may partially overlap any Location within the same virtual variable.
    def.getVirtualVariable() = use.getVirtualVariable() and
    def instanceof UnknownMemoryLocation and result instanceof MayPartiallyOverlap
    or
    exists(IndirectMemoryLocation defIndirectLocation |
      defIndirectLocation = def and
      (
        (
          // An IndirectMemoryLocation may partially overlap an unknown location within the same virtual variable.
          def.getVirtualVariable() = use.getVirtualVariable() and
          ((use instanceof UnknownMemoryLocation) or (use instanceof UnknownVirtualVariable)) and
          result instanceof MayPartiallyOverlap
        ) or
        // An IndirectMemoryLocation overlaps another location with the same constant base address
        // based on the relationship of the two offset intervals.
        exists(Overlap intervalOverlap |
          intervalOverlap = getIndirectMemoryLocationOverlap(def, use) and
          if intervalOverlap instanceof MustExactlyOverlap then (
            if def.getType() = use.getType() then (
              // The def and use types match, so it's an exact overlap.
              result instanceof MustExactlyOverlap
            )
            else (
              // The def and use types are not the same, so it's just a total overlap.
              result instanceof MustTotallyOverlap
            )
          )
          else if defIndirectLocation.coversEntireVariable() then (
            // The definition covers the entire variable, so assume that it totally overlaps the use, even if the
            // interval for the use is unknown or outside the bounds of the variable.
            result instanceof MustTotallyOverlap
          )
          else (
            // Just use the overlap relation of the interval.
            result = intervalOverlap
          )
        )
      )
    )
  )
}

/*
 * The following predicates compute the overlap relation between `IndirectMemoryLocation`s in the
 * same `VirtualVariable` as follows:
 *   1. In `isRelevantOffset`, compute the set of offsets within each virtual variable (linear in
 *      the number of IMLs)
 *   2. In `isCoveredOffset`, rank the offsets within each virtual variable (linear in the number
 *      of IMLs)
 *   3. In `isCoveredOffset`, compute the set of ranks that each IML with known start and end
 *      offsets covers (linear in the size of the overlap set)
 *   4. In `overlappingIndirectMemoryLocations`, compute the set of overlapping pairs of IMLs using a
 *      join on `isCoveredOffset` (linear in the size of the overlap set)
 *   5. In `overlappingIndirectMemoryLocationsWithBase`, restrict to only the pairs that share the
 *      same base address. (linear in the size of the overlap set)
 *   6. In `getIndirectMemoryLocationOverlap`, compute the precise overlap relation for each
 *      overlapping pair of IMLs (linear in the size of the overlap set)
 */
private predicate isRelevantOffset(ValueNumber baseAddress, IntValue offset) {
  exists(IndirectMemoryLocation ml |
    ml.getBaseAddress() = baseAddress
    |
    ml.getStartBitOffset() = offset
    or
    ml.getEndBitOffset() = offset
  )
}

private predicate isRelatableMemoryLocation(IndirectMemoryLocation vml) {
  vml.getEndBitOffset() != Ints::unknown() and
  vml.getStartBitOffset() != Ints::unknown()
}

private predicate isCoveredOffset(IndirectMemoryLocation vml, ValueNumber baseAddress,
    int offsetRank) {
  exists(int startRank, int endRank |
    vml.getStartBitOffset() = rank[startRank](IntValue offset_ | isRelevantOffset(baseAddress, offset_)) and
    vml.getEndBitOffset() = rank[endRank](IntValue offset_ | isRelevantOffset(baseAddress, offset_)) and
    baseAddress = vml.getBaseAddress() and
    isRelatableMemoryLocation(vml) and
    offsetRank in [startRank .. endRank]
  )
}

private predicate hasUnknownOffset(IndirectMemoryLocation vml, VirtualVariable vv) {
  vml.getVirtualVariable() = vv and
  (
    vml.getStartBitOffset() = Ints::unknown() or
    vml.getEndBitOffset() = Ints::unknown()
  )
}

private predicate overlappingIndirectMemoryLocations(IndirectMemoryLocation def, IndirectMemoryLocation use) {
    exists(ValueNumber baseAddress, int offsetRank |
      isCoveredOffset(def, baseAddress, offsetRank) and isCoveredOffset(use, baseAddress, offsetRank))
    or
    hasUnknownOffset(def, use.getVirtualVariable())
    or
    hasUnknownOffset(use, def.getVirtualVariable())
}

pragma[noopt] // Internal ticket: QL-937
private predicate overlappingIndirectMemoryLocationsWithBase(IndirectMemoryLocation def, IndirectMemoryLocation use) {
  overlappingIndirectMemoryLocations(def, use) and
  def.getBaseAddress() = use.getBaseAddress()
}

private Overlap getIndirectMemoryLocationOverlap(IndirectMemoryLocation def, IndirectMemoryLocation use) {
  (
    // If the two locations have the same base address, they overlap based on their offset ranges.
    overlappingIndirectMemoryLocationsWithBase(def, use) and
    result = Interval::getOverlap(def.getStartBitOffset(), def.getEndBitOffset(), use.getStartBitOffset(), use.getEndBitOffset())
  ) or
  (
    // If they do not share the same base address, then they may partially overlap unless they both
    // have an allocation and the two allocations are different.
    def.getVirtualVariable() = use.getVirtualVariable() and
    def.getBaseAddress() != use.getBaseAddress() and
    not (def.getAllocation() != use.getAllocation()) and
    result instanceof MayPartiallyOverlap
  )
}

private MemoryLocation getMemoryLocation(AddressOperand addrOperand) {
  exists(Type type, ValueNumber baseAddress, IntValue startBitOffset, IntValue endBitOffset |
    hasMemoryAccess(addrOperand, type, baseAddress, startBitOffset, endBitOffset) and
    result = TIndirectMemoryLocation(type, baseAddress, startBitOffset, endBitOffset)
  )
}

MemoryLocation getResultMemoryLocation(Instruction instr) {
  result = getMemoryLocation(instr.getResultAddressOperand()) or
  exists(MemoryAccessKind kind |
    kind = instr.getResultMemoryAccess() and
    (
      (
        kind instanceof EscapedMemoryAccess and
        result = TUnknownVirtualVariable(instr.getEnclosingIRFunction())
      ) or
      (
        kind instanceof EscapedMayMemoryAccess and
        result = TUnknownMemoryLocation(instr.getEnclosingIRFunction())
      )
    )
  )
}

MemoryLocation getOperandMemoryLocation(MemoryOperand operand) {
  result = getMemoryLocation(operand.getAddressOperand()) or
  exists(MemoryAccessKind kind |
    kind = operand.getMemoryAccess() and
    (
      (
        kind instanceof EscapedMemoryAccess and
        result = TUnknownVirtualVariable(operand.getEnclosingIRFunction())
      ) or
      (
        kind instanceof EscapedMayMemoryAccess and
        result = TUnknownMemoryLocation(operand.getEnclosingIRFunction())
      )
    )
  )
}
