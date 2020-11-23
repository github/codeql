import AliasAnalysis
import semmle.code.cpp.ir.internal.Overlap
private import semmle.code.cpp.ir.internal.IRCppLanguage as Language
private import semmle.code.cpp.Print
private import semmle.code.cpp.ir.implementation.unaliased_ssa.IR
private import semmle.code.cpp.ir.internal.IntegerConstant as Ints
private import semmle.code.cpp.ir.internal.IntegerInterval as Interval
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import AliasConfiguration

private class IntValue = Ints::IntValue;

private predicate isIndirectOrBufferMemoryAccess(MemoryAccessKind kind) {
  kind instanceof IndirectMemoryAccess or
  kind instanceof BufferMemoryAccess
}

private predicate hasResultMemoryAccess(
  Instruction instr, Allocation var, IRType type, Language::LanguageType languageType,
  IntValue startBitOffset, IntValue endBitOffset, boolean isMayAccess
) {
  exists(AddressOperand addrOperand |
    addrOperand = instr.getResultAddressOperand() and
    addressOperandAllocationAndOffset(addrOperand, var, startBitOffset) and
    languageType = instr.getResultLanguageType() and
    type = languageType.getIRType() and
    isIndirectOrBufferMemoryAccess(instr.getResultMemoryAccess()) and
    (if instr.hasResultMayMemoryAccess() then isMayAccess = true else isMayAccess = false) and
    if exists(type.getByteSize())
    then endBitOffset = Ints::add(startBitOffset, Ints::mul(type.getByteSize(), 8))
    else endBitOffset = Ints::unknown()
  )
}

private predicate hasOperandMemoryAccess(
  MemoryOperand operand, Allocation var, IRType type, Language::LanguageType languageType,
  IntValue startBitOffset, IntValue endBitOffset, boolean isMayAccess
) {
  exists(AddressOperand addrOperand |
    addrOperand = operand.getAddressOperand() and
    addressOperandAllocationAndOffset(addrOperand, var, startBitOffset) and
    languageType = operand.getLanguageType() and
    type = languageType.getIRType() and
    isIndirectOrBufferMemoryAccess(operand.getMemoryAccess()) and
    (if operand.hasMayReadMemoryAccess() then isMayAccess = true else isMayAccess = false) and
    if exists(type.getByteSize())
    then endBitOffset = Ints::add(startBitOffset, Ints::mul(type.getByteSize(), 8))
    else endBitOffset = Ints::unknown()
  )
}

private newtype TMemoryLocation =
  TVariableMemoryLocation(
    Allocation var, IRType type, Language::LanguageType languageType, IntValue startBitOffset,
    IntValue endBitOffset, boolean isMayAccess
  ) {
    (
      hasResultMemoryAccess(_, var, type, _, startBitOffset, endBitOffset, isMayAccess)
      or
      hasOperandMemoryAccess(_, var, type, _, startBitOffset, endBitOffset, isMayAccess)
      or
      // For a stack variable, always create a memory location for the entire variable.
      var.isAlwaysAllocatedOnStack() and
      type = var.getIRType() and
      startBitOffset = 0 and
      endBitOffset = type.getByteSize() * 8 and
      isMayAccess = false
    ) and
    languageType = type.getCanonicalLanguageType()
  } or
  TEntireAllocationMemoryLocation(Allocation var, boolean isMayAccess) {
    (
      var instanceof IndirectParameterAllocation or
      var instanceof DynamicAllocation
    ) and
    (isMayAccess = false or isMayAccess = true)
  } or
  TUnknownMemoryLocation(IRFunction irFunc, boolean isMayAccess) {
    isMayAccess = false or isMayAccess = true
  } or
  TAllNonLocalMemory(IRFunction irFunc, boolean isMayAccess) {
    isMayAccess = false or isMayAccess = true
  } or
  TAllAliasedMemory(IRFunction irFunc, boolean isMayAccess, boolean canDefineReadOnly) {
    isMayAccess = false and
    canDefineReadOnly = [true, false]
    or
    isMayAccess = true and canDefineReadOnly = false
  }

/**
 * Represents the memory location accessed by a memory operand or memory result. In this implementation, the location is
 * one of the following:
 * - `VariableMemoryLocation` - A location within a known `IRVariable`, at an offset that is either a constant or is
 * unknown.
 * - `UnknownMemoryLocation` - A location not known to be within a specific `IRVariable`.
 */
abstract class MemoryLocation extends TMemoryLocation {
  final string toString() {
    if isMayAccess() then result = "?" + toStringInternal() else result = toStringInternal()
  }

  abstract string toStringInternal();

  abstract VirtualVariable getVirtualVariable();

  abstract Language::LanguageType getType();

  abstract string getUniqueId();

  abstract IRFunction getIRFunction();

  abstract Location getLocation();

  final IRType getIRType() { result = getType().getIRType() }

  abstract predicate isMayAccess();

  Allocation getAllocation() { none() }

  /**
   * Holds if the location cannot be overwritten except by definition of a `MemoryLocation` for
   * which `def.canDefineReadOnly()` holds.
   */
  predicate isReadOnly() { none() }

  /**
   * Holds if a definition of this location can be the definition of a read-only use location.
   */
  predicate canDefineReadOnly() { none() }

  /**
   * Holds if the location always represents memory allocated on the stack (for example, a variable
   * with automatic storage duration).
   */
  predicate isAlwaysAllocatedOnStack() { none() }
}

/**
 * Represents a set of `MemoryLocation`s that cannot overlap with
 * `MemoryLocation`s outside of the set. The `VirtualVariable` will be
 * represented by a `MemoryLocation` that totally overlaps all other
 * `MemoryLocations` in the set.
 */
abstract class VirtualVariable extends MemoryLocation { }

abstract class AllocationMemoryLocation extends MemoryLocation {
  Allocation var;
  boolean isMayAccess;

  AllocationMemoryLocation() {
    this instanceof TMemoryLocation and
    isMayAccess = false
    or
    isMayAccess = true // Just ensures that `isMayAccess` is bound.
  }

  final override VirtualVariable getVirtualVariable() {
    if allocationEscapes(var)
    then result = TAllAliasedMemory(var.getEnclosingIRFunction(), false, true)
    else result.(AllocationMemoryLocation).getAllocation() = var
  }

  final override IRFunction getIRFunction() { result = var.getEnclosingIRFunction() }

  final override Location getLocation() { result = var.getLocation() }

  final override Allocation getAllocation() { result = var }

  final override predicate isMayAccess() { isMayAccess = true }

  final override predicate isReadOnly() { var.isReadOnly() }
}

/**
 * An access to memory within a single known `IRVariable`. The variable may be either an unescaped variable
 * (with its own `VirtualIRVariable`) or an escaped variable (assigned to `UnknownVirtualVariable`).
 */
class VariableMemoryLocation extends TVariableMemoryLocation, AllocationMemoryLocation {
  IRType type;
  Language::LanguageType languageType;
  IntValue startBitOffset;
  IntValue endBitOffset;

  VariableMemoryLocation() {
    this =
      TVariableMemoryLocation(var, type, languageType, startBitOffset, endBitOffset, isMayAccess)
  }

  private string getIntervalString() {
    if coversEntireVariable()
    then result = ""
    else result = Interval::getIntervalString(startBitOffset, endBitOffset)
  }

  private string getTypeString() {
    if coversEntireVariable() and type = var.getIRType()
    then result = ""
    else result = "<" + languageType.toString() + ">"
  }

  final override string toStringInternal() {
    result = var.toString() + getIntervalString() + getTypeString()
  }

  final override Language::LanguageType getType() {
    if
      strictcount(Language::LanguageType accessType |
        hasResultMemoryAccess(_, var, type, accessType, startBitOffset, endBitOffset, _) or
        hasOperandMemoryAccess(_, var, type, accessType, startBitOffset, endBitOffset, _)
      ) = 1
    then
      // All of the accesses have the same `LanguageType`, so just use that.
      hasResultMemoryAccess(_, var, type, result, startBitOffset, endBitOffset, _) or
      hasOperandMemoryAccess(_, var, type, result, startBitOffset, endBitOffset, _)
    else
      // There is no single type for all accesses, so just use the canonical one for this `IRType`.
      result = type.getCanonicalLanguageType()
  }

  final IntValue getStartBitOffset() { result = startBitOffset }

  final IntValue getEndBitOffset() { result = endBitOffset }

  final override string getUniqueId() {
    result =
      var.getUniqueId() + Interval::getIntervalString(startBitOffset, endBitOffset) + "<" +
        type.getIdentityString() + ">"
  }

  final override predicate isAlwaysAllocatedOnStack() { var.isAlwaysAllocatedOnStack() }

  /**
   * Holds if this memory location covers the entire variable.
   */
  final predicate coversEntireVariable() { varIRTypeHasBitRange(startBitOffset, endBitOffset) }

  pragma[noinline]
  private predicate varIRTypeHasBitRange(int start, int end) {
    start = 0 and
    end = var.getIRType().getByteSize() * 8
  }
}

class EntireAllocationMemoryLocation extends TEntireAllocationMemoryLocation,
  AllocationMemoryLocation {
  EntireAllocationMemoryLocation() { this = TEntireAllocationMemoryLocation(var, isMayAccess) }

  final override string toStringInternal() { result = var.toString() }

  final override Language::LanguageType getType() {
    result = any(IRUnknownType unknownType).getCanonicalLanguageType()
  }

  final override string getUniqueId() { result = var.getUniqueId() }
}

class EntireAllocationVirtualVariable extends EntireAllocationMemoryLocation, VirtualVariable {
  EntireAllocationVirtualVariable() {
    not allocationEscapes(var) and
    not isMayAccess()
  }
}

/**
 * Represents the `MemoryLocation` for an `IRVariable` that acts as its own `VirtualVariable`. Includes any
 * `VariableMemoryLocation` that exactly overlaps its entire `IRVariable`, and only if that `IRVariable` does not
 * escape.
 */
class VariableVirtualVariable extends VariableMemoryLocation, VirtualVariable {
  VariableVirtualVariable() {
    not allocationEscapes(var) and
    type = var.getIRType() and
    coversEntireVariable() and
    not isMayAccess()
  }
}

/**
 * An access to memory that is not known to be confined to a specific `IRVariable`.
 */
class UnknownMemoryLocation extends TUnknownMemoryLocation, MemoryLocation {
  IRFunction irFunc;
  boolean isMayAccess;

  UnknownMemoryLocation() { this = TUnknownMemoryLocation(irFunc, isMayAccess) }

  final override string toStringInternal() { result = "{Unknown}" }

  final override VirtualVariable getVirtualVariable() {
    result = TAllAliasedMemory(irFunc, false, true)
  }

  final override Language::LanguageType getType() {
    result = any(IRUnknownType type).getCanonicalLanguageType()
  }

  final override IRFunction getIRFunction() { result = irFunc }

  final override Location getLocation() { result = irFunc.getLocation() }

  final override string getUniqueId() { result = "{Unknown}" }

  final override predicate isMayAccess() { isMayAccess = true }
}

/**
 * An access to memory that is not known to be confined to a specific `IRVariable`, but is known to
 * not access memory on the current function's stack frame.
 */
class AllNonLocalMemory extends TAllNonLocalMemory, MemoryLocation {
  IRFunction irFunc;
  boolean isMayAccess;

  AllNonLocalMemory() { this = TAllNonLocalMemory(irFunc, isMayAccess) }

  final override string toStringInternal() { result = "{AllNonLocal}" }

  final override AliasedVirtualVariable getVirtualVariable() { result.getIRFunction() = irFunc }

  final override Language::LanguageType getType() {
    result = any(IRUnknownType type).getCanonicalLanguageType()
  }

  final override IRFunction getIRFunction() { result = irFunc }

  final override Location getLocation() { result = irFunc.getLocation() }

  final override string getUniqueId() { result = "{AllNonLocal}" }

  final override predicate isMayAccess() { isMayAccess = true }

  override predicate canDefineReadOnly() { none() }
}

/**
 * An access to all aliased memory.
 */
class AllAliasedMemory extends TAllAliasedMemory, MemoryLocation {
  IRFunction irFunc;
  boolean isMayAccess;
  boolean canDefineReadOnly;

  AllAliasedMemory() { this = TAllAliasedMemory(irFunc, isMayAccess, canDefineReadOnly) }

  final override string toStringInternal() { result = "{AllAliased}" }

  final override Language::LanguageType getType() {
    result = any(IRUnknownType type).getCanonicalLanguageType()
  }

  final override IRFunction getIRFunction() { result = irFunc }

  final override Location getLocation() { result = irFunc.getLocation() }

  final override string getUniqueId() { result = " " + toString() }

  final override VirtualVariable getVirtualVariable() {
    result = TAllAliasedMemory(irFunc, false, true)
  }

  final override predicate isMayAccess() { isMayAccess = true }

  final override predicate canDefineReadOnly() { canDefineReadOnly = true }
}

/** A virtual variable that groups all escaped memory within a function. */
class AliasedVirtualVariable extends AllAliasedMemory, VirtualVariable {
  AliasedVirtualVariable() { not isMayAccess() and canDefineReadOnly() }
}

/**
 * Gets the overlap relationship between the definition location `def` and the use location `use`.
 */
Overlap getOverlap(MemoryLocation def, MemoryLocation use) {
  exists(Overlap overlap |
    // Compute the overlap based only on the extent.
    overlap = getExtentOverlap(def, use) and
    // Filter out attempts to write to read-only memory.
    (def.canDefineReadOnly() or not use.isReadOnly()) and
    if def.isMayAccess()
    then
      // No matter what kind of extent overlap we have, the final overlap is still
      // `MayPartiallyOverlap`, because the def might not have written all of the bits of the use
      // location.
      result instanceof MayPartiallyOverlap
    else
      if
        overlap instanceof MustExactlyOverlap and
        (use.isMayAccess() or not def.getIRType() = use.getIRType())
      then
        // Can't exactly overlap with a "may" use or a use of a different type.
        result instanceof MustTotallyOverlap
      else result = overlap
  )
}

/**
 * Gets the overlap relationship between the definition location `def` and the use location `use`,
 * based only on the set of memory locations accessed. Handling of "may" accesses and read-only
 * locations occurs in `getOverlap()`.
 */
private Overlap getExtentOverlap(MemoryLocation def, MemoryLocation use) {
  // The def and the use must have the same virtual variable, or no overlap is possible.
  (
    // AllAliasedMemory must totally overlap any location within the same virtual variable.
    def.getVirtualVariable() = use.getVirtualVariable() and
    def instanceof AllAliasedMemory and
    result instanceof MustTotallyOverlap
    or
    // An UnknownMemoryLocation may partially overlap any Location within the same virtual variable,
    // even itself.
    def.getVirtualVariable() = use.getVirtualVariable() and
    def instanceof UnknownMemoryLocation and
    result instanceof MayPartiallyOverlap
    or
    def.getVirtualVariable() = use.getVirtualVariable() and
    def instanceof AllNonLocalMemory and
    (
      // AllNonLocalMemory exactly overlaps itself.
      use instanceof AllNonLocalMemory and
      result instanceof MustExactlyOverlap
      or
      not use instanceof AllNonLocalMemory and
      not use.isAlwaysAllocatedOnStack() and
      if use instanceof VariableMemoryLocation
      then
        // AllNonLocalMemory totally overlaps any non-local variable.
        result instanceof MustTotallyOverlap
      else
        // AllNonLocalMemory may partially overlap any other location within the same virtual
        // variable, except a stack variable.
        result instanceof MayPartiallyOverlap
    )
    or
    def.getVirtualVariable() = use.getVirtualVariable() and
    def instanceof EntireAllocationMemoryLocation and
    (
      // EntireAllocationMemoryLocation exactly overlaps itself.
      use instanceof EntireAllocationMemoryLocation and
      result instanceof MustExactlyOverlap
      or
      not use instanceof EntireAllocationMemoryLocation and
      if def.getAllocation() = use.getAllocation()
      then
        // EntireAllocationMemoryLocation totally overlaps any location within
        // the same allocation.
        result instanceof MustTotallyOverlap
      else (
        // There is no overlap with a location that's known to belong to a
        // different allocation, but all other locations may partially overlap.
        not exists(use.getAllocation()) and
        result instanceof MayPartiallyOverlap
      )
    )
    or
    exists(VariableMemoryLocation defVariableLocation |
      defVariableLocation = def and
      (
        // A VariableMemoryLocation may partially overlap an unknown location within the same
        // virtual variable.
        def.getVirtualVariable() = use.getVirtualVariable() and
        (
          use instanceof UnknownMemoryLocation or
          use instanceof AllAliasedMemory or
          use instanceof EntireAllocationMemoryLocation
        ) and
        result instanceof MayPartiallyOverlap
        or
        // A VariableMemoryLocation that is not a local variable may partially overlap an
        // AllNonLocalMemory within the same virtual variable.
        def.getVirtualVariable() = use.getVirtualVariable() and
        use instanceof AllNonLocalMemory and
        result instanceof MayPartiallyOverlap and
        not defVariableLocation.isAlwaysAllocatedOnStack()
        or
        // A VariableMemoryLocation overlaps another location within the same variable based on the
        // relationship of the two offset intervals.
        exists(Overlap intervalOverlap |
          intervalOverlap = getVariableMemoryLocationOverlap(def, use) and
          if intervalOverlap instanceof MustExactlyOverlap
          then result instanceof MustExactlyOverlap
          else
            if defVariableLocation.coversEntireVariable()
            then
              // The definition covers the entire variable, so assume that it totally overlaps the use, even if the
              // interval for the use is unknown or outside the bounds of the variable.
              result instanceof MustTotallyOverlap
            else
              // Just use the overlap relation of the interval.
              result = intervalOverlap
        )
      )
    )
  )
}

/*
 * The following predicates compute the overlap relation between `VariableMemoryLocation`s in the
 * same `VirtualVariable` as follows:
 *   1. In `isRelevantOffset`, compute the set of offsets within each virtual variable (linear in
 *      the number of VMLs)
 *   2. In `isCoveredOffset`, rank the offsets within each virtual variable (linear in the number
 *      of VMLs)
 *   3. In `isCoveredOffset`, compute the set of ranks that each VML with known start and end
 *      offsets covers (linear in the size of the overlap set)
 *   4. In `overlappingVariableMemoryLocations`, compute the set of overlapping pairs of VMLs using a
 *      join on `isCoveredOffset` (linear in the size of the overlap set)
 *   5. In `overlappingIRVariableMemoryLocations`, restrict to only the pairs that share an
 *      `IRVariable` (linear in the size of the overlap set)
 *   5. In `getVariableMemoryLocationOverlap`, compute the precise overlap relation for each
 *      overlapping pair of VMLs (linear in the size of the overlap set)
 */

private predicate isRelevantOffset(VirtualVariable vv, IntValue offset) {
  exists(VariableMemoryLocation ml | ml.getVirtualVariable() = vv |
    ml.getStartBitOffset() = offset
    or
    ml.getEndBitOffset() = offset
  )
}

private predicate isRelatableMemoryLocation(VariableMemoryLocation vml) {
  vml.getEndBitOffset() != Ints::unknown() and
  vml.getStartBitOffset() != Ints::unknown()
}

private predicate isCoveredOffset(Allocation var, int offsetRank, VariableMemoryLocation vml) {
  exists(int startRank, int endRank, VirtualVariable vvar |
    vml.getStartBitOffset() = rank[startRank](IntValue offset_ | isRelevantOffset(vvar, offset_)) and
    vml.getEndBitOffset() = rank[endRank](IntValue offset_ | isRelevantOffset(vvar, offset_)) and
    var = vml.getAllocation() and
    vvar = vml.getVirtualVariable() and
    isRelatableMemoryLocation(vml) and
    offsetRank in [startRank .. endRank]
  )
}

private predicate hasUnknownOffset(Allocation var, VariableMemoryLocation vml) {
  vml.getAllocation() = var and
  (
    vml.getStartBitOffset() = Ints::unknown() or
    vml.getEndBitOffset() = Ints::unknown()
  )
}

private predicate overlappingIRVariableMemoryLocations(
  VariableMemoryLocation def, VariableMemoryLocation use
) {
  exists(Allocation var, int offsetRank |
    isCoveredOffset(var, offsetRank, def) and
    isCoveredOffset(var, offsetRank, use)
  )
  or
  hasUnknownOffset(use.getAllocation(), def)
  or
  hasUnknownOffset(def.getAllocation(), use)
}

private Overlap getVariableMemoryLocationOverlap(
  VariableMemoryLocation def, VariableMemoryLocation use
) {
  overlappingIRVariableMemoryLocations(def, use) and
  result =
    Interval::getOverlap(def.getStartBitOffset(), def.getEndBitOffset(), use.getStartBitOffset(),
      use.getEndBitOffset())
}

bindingset[result, b]
private boolean unbindBool(boolean b) { result != b.booleanNot() }

MemoryLocation getResultMemoryLocation(Instruction instr) {
  exists(MemoryAccessKind kind, boolean isMayAccess |
    kind = instr.getResultMemoryAccess() and
    (if instr.hasResultMayMemoryAccess() then isMayAccess = true else isMayAccess = false) and
    (
      (
        isIndirectOrBufferMemoryAccess(kind) and
        if hasResultMemoryAccess(instr, _, _, _, _, _, _)
        then
          exists(Allocation var, IRType type, IntValue startBitOffset, IntValue endBitOffset |
            hasResultMemoryAccess(instr, var, type, _, startBitOffset, endBitOffset, isMayAccess) and
            result =
              TVariableMemoryLocation(var, type, _, startBitOffset, endBitOffset,
                unbindBool(isMayAccess))
          )
        else result = TUnknownMemoryLocation(instr.getEnclosingIRFunction(), isMayAccess)
      )
      or
      kind instanceof EntireAllocationMemoryAccess and
      result =
        TEntireAllocationMemoryLocation(getAddressOperandAllocation(instr.getResultAddressOperand()),
          unbindBool(isMayAccess))
      or
      kind instanceof EscapedMemoryAccess and
      result = TAllAliasedMemory(instr.getEnclosingIRFunction(), isMayAccess, false)
      or
      kind instanceof EscapedInitializationMemoryAccess and
      result = TAllAliasedMemory(instr.getEnclosingIRFunction(), false, true)
      or
      kind instanceof NonLocalMemoryAccess and
      result = TAllNonLocalMemory(instr.getEnclosingIRFunction(), isMayAccess)
    )
  )
}

MemoryLocation getOperandMemoryLocation(MemoryOperand operand) {
  exists(MemoryAccessKind kind, boolean isMayAccess |
    kind = operand.getMemoryAccess() and
    (if operand.hasMayReadMemoryAccess() then isMayAccess = true else isMayAccess = false) and
    (
      (
        isIndirectOrBufferMemoryAccess(kind) and
        if hasOperandMemoryAccess(operand, _, _, _, _, _, _)
        then
          exists(Allocation var, IRType type, IntValue startBitOffset, IntValue endBitOffset |
            hasOperandMemoryAccess(operand, var, type, _, startBitOffset, endBitOffset, isMayAccess) and
            result =
              TVariableMemoryLocation(var, type, _, startBitOffset, endBitOffset, isMayAccess)
          )
        else result = TUnknownMemoryLocation(operand.getEnclosingIRFunction(), isMayAccess)
      )
      or
      kind instanceof EntireAllocationMemoryAccess and
      result =
        TEntireAllocationMemoryLocation(getAddressOperandAllocation(operand.getAddressOperand()),
          isMayAccess)
      or
      kind instanceof EscapedMemoryAccess and
      result = TAllAliasedMemory(operand.getEnclosingIRFunction(), isMayAccess, false)
      or
      kind instanceof EscapedInitializationMemoryAccess and
      result = TAllAliasedMemory(operand.getEnclosingIRFunction(), false, true)
      or
      kind instanceof NonLocalMemoryAccess and
      result = TAllNonLocalMemory(operand.getEnclosingIRFunction(), isMayAccess)
    )
  )
}

/** Gets the start bit offset of a `MemoryLocation`, if any. */
int getStartBitOffset(VariableMemoryLocation location) { result = location.getStartBitOffset() }

/** Gets the end bit offset of a `MemoryLocation`, if any. */
int getEndBitOffset(VariableMemoryLocation location) { result = location.getEndBitOffset() }
