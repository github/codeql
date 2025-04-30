import AliasAnalysis
import semmle.code.cpp.Location
import semmle.code.cpp.ir.internal.Overlap
private import semmle.code.cpp.ir.internal.IRCppLanguage as Language
private import semmle.code.cpp.ir.implementation.unaliased_ssa.IR
private import semmle.code.cpp.ir.implementation.unaliased_ssa.internal.SSAConstruction as OldSsa
private import semmle.code.cpp.ir.internal.IntegerConstant as Ints
private import semmle.code.cpp.ir.internal.IntegerInterval as Interval
private import semmle.code.cpp.ir.implementation.internal.OperandTag
import AliasConfiguration
private import codeql.util.Boolean

private class IntValue = Ints::IntValue;

private predicate isIndirectOrBufferMemoryAccess(MemoryAccessKind kind) {
  kind instanceof IndirectMemoryAccess or
  kind instanceof BufferMemoryAccess
}

private predicate hasMemoryAccess(
  AddressOperand addrOperand, Allocation var, IntValue startBitOffset, boolean grouped
) {
  addressOperandAllocationAndOffset(addrOperand, var, startBitOffset) and
  if strictcount(Allocation alloc | addressOperandAllocationAndOffset(addrOperand, alloc, _)) > 1
  then grouped = true
  else grouped = false
}

private predicate hasResultMemoryAccess(
  AddressOperand address, Instruction instr, Allocation var, IRType type,
  Language::LanguageType languageType, IntValue startBitOffset, IntValue endBitOffset,
  boolean isMayAccess, boolean grouped
) {
  address = instr.getResultAddressOperand() and
  hasMemoryAccess(address, var, startBitOffset, grouped) and
  languageType = instr.getResultLanguageType() and
  type = languageType.getIRType() and
  isIndirectOrBufferMemoryAccess(instr.getResultMemoryAccess()) and
  (if instr.hasResultMayMemoryAccess() then isMayAccess = true else isMayAccess = false) and
  if exists(type.getByteSize())
  then endBitOffset = Ints::add(startBitOffset, Ints::mul(type.getByteSize(), 8))
  else endBitOffset = Ints::unknown()
}

private predicate hasOperandMemoryAccess(
  AddressOperand address, MemoryOperand operand, Allocation var, IRType type,
  Language::LanguageType languageType, IntValue startBitOffset, IntValue endBitOffset,
  boolean isMayAccess, boolean grouped
) {
  address = operand.getAddressOperand() and
  hasMemoryAccess(address, var, startBitOffset, grouped) and
  languageType = operand.getLanguageType() and
  type = languageType.getIRType() and
  isIndirectOrBufferMemoryAccess(operand.getMemoryAccess()) and
  (if operand.hasMayReadMemoryAccess() then isMayAccess = true else isMayAccess = false) and
  if exists(type.getByteSize())
  then endBitOffset = Ints::add(startBitOffset, Ints::mul(type.getByteSize(), 8))
  else endBitOffset = Ints::unknown()
}

private Allocation getAnAllocation(AddressOperand address) {
  hasResultMemoryAccess(address, _, result, _, _, _, _, _, true) or
  hasOperandMemoryAccess(address, _, result, _, _, _, _, _, true)
}

private module AllocationSet0 =
  QlBuiltins::InternSets<AddressOperand, Allocation, getAnAllocation/1>;

/**
 * A set of allocations containing at least 2 elements.
 */
private class NonSingletonSets extends AllocationSet0::Set {
  NonSingletonSets() { strictcount(Allocation var | this.contains(var)) > 1 }

  /** Gets an allocation from this set. */
  Allocation getAnAllocation() { this.contains(result) }

  /** Gets the string representation of this set. */
  string toString() { result = "{" + strictconcat(this.getAnAllocation().toString(), ", ") + "}" }
}

/** Holds the instersection of `s1` and `s2` is non-empty. */
private predicate hasOverlappingElement(NonSingletonSets s1, NonSingletonSets s2) {
  exists(Allocation var |
    s1.contains(var) and
    s2.contains(var)
  )
}

private module AllocationSet =
  QlBuiltins::EquivalenceRelation<NonSingletonSets, hasOverlappingElement/2>;

/**
 * Holds if `var` is created by the AST element `e`. Furthermore, the value `d`
 * represents which branch of the `Allocation` type `var` is from.
 */
private predicate allocationAst(Allocation var, @element e, int d) {
  var.(VariableAllocation).getIRVariable().getAst() = e and d = 0
  or
  var.(IndirectParameterAllocation).getIRVariable().getAst() = e and d = 1
  or
  var.(DynamicAllocation).getABaseInstruction().getAst() = e and d = 2
}

/** Holds if `x = y` and `x` is an AST element that creates an `Allocation`. */
private predicate id(@element x, @element y) {
  allocationAst(_, x, _) and
  x = y
}

private predicate idOf(@element x, int y) = equivalenceRelation(id/2)(x, y)

/** Gets a unique integer representation of `var`. */
private int getUniqueAllocationId(Allocation var) {
  exists(int r, @element e, int d |
    allocationAst(var, e, d) and
    idOf(e, r) and
    result = 3 * r + d
  )
}

/**
 * An equivalence class of a set of allocations.
 *
 * Any `VariableGroup` will be completely disjunct from any other
 * `VariableGroup`.
 */
class VariableGroup extends AllocationSet::EquivalenceClass {
  /** Gets the location of this set. */
  final Location getLocation() { result = this.getIRFunction().getLocation() }

  /** Gets the enclosing `IRFunction` of this set. */
  final IRFunction getIRFunction() {
    result = unique( | | this.getAnAllocation().getEnclosingIRFunction())
  }

  /** Gets the type of elements contained in this set. */
  final Language::LanguageType getType() {
    strictcount(Language::LanguageType langType |
      exists(Allocation var | var = this.getAnAllocation() |
        hasResultMemoryAccess(_, _, var, _, langType, _, _, _, true) or
        hasOperandMemoryAccess(_, _, var, _, langType, _, _, _, true)
      )
    ) = 1 and
    exists(Allocation var | var = this.getAnAllocation() |
      hasResultMemoryAccess(_, _, var, _, result, _, _, _, true) or
      hasOperandMemoryAccess(_, _, var, _, result, _, _, _, true)
    )
    or
    strictcount(Language::LanguageType langType |
      exists(Allocation var | var = this.getAnAllocation() |
        hasResultMemoryAccess(_, _, var, _, langType, _, _, _, true) or
        hasOperandMemoryAccess(_, _, var, _, langType, _, _, _, true)
      )
    ) > 1 and
    result = any(IRUnknownType type).getCanonicalLanguageType()
  }

  /** Gets an allocation of this set. */
  final Allocation getAnAllocation() {
    exists(AllocationSet0::Set set |
      this = AllocationSet::getEquivalenceClass(set) and
      set.contains(result)
    )
  }

  /** Gets a unique string representing this set. */
  final private string getUniqueId() {
    result = strictconcat(getUniqueAllocationId(this.getAnAllocation()).toString(), ",")
  }

  /**
   * Gets the order that this set should be initialized in.
   *
   * Note: This is _not_ the order in which the _members_ of the set should be
   * initialized. Rather, it represents the order in which the set should be
   * initialized in relation to other sets. That is, if
   * ```
   * getInitializationOrder() = 2
   * ```
   * then this set will be initialized as the second (third) set in the
   * enclosing function. In order words, the third `UninitializedGroup`
   * instruction in the entry block of the enclosing function will initialize
   * this set of allocations.
   */
  final int getInitializationOrder() {
    exists(IRFunction func |
      func = this.getIRFunction() and
      this =
        rank[result + 1](VariableGroup vg, string uniq |
          vg.getIRFunction() = func and uniq = vg.getUniqueId()
        |
          vg order by uniq
        )
    )
  }

  string toString() { result = "{" + strictconcat(this.getAnAllocation().toString(), ", ") + "}" }
}

private newtype TMemoryLocation =
  TVariableMemoryLocation(
    Allocation var, IRType type, Language::LanguageType languageType, IntValue startBitOffset,
    IntValue endBitOffset, boolean isMayAccess
  ) {
    (
      hasResultMemoryAccess(_, _, var, type, _, startBitOffset, endBitOffset, isMayAccess, false)
      or
      hasOperandMemoryAccess(_, _, var, type, _, startBitOffset, endBitOffset, isMayAccess, false)
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
  TEntireAllocationMemoryLocation(Allocation var, Boolean isMayAccess) {
    var instanceof IndirectParameterAllocation or
    var instanceof DynamicAllocation
  } or
  TGroupedMemoryLocation(VariableGroup vg, Boolean isMayAccess, Boolean isAll) or
  TUnknownMemoryLocation(IRFunction irFunc, Boolean isMayAccess) or
  TAllNonLocalMemory(IRFunction irFunc, Boolean isMayAccess) or
  TAllAliasedMemory(IRFunction irFunc, Boolean isMayAccess)

/**
 * A memory location accessed by a memory operand or memory result. In this implementation, the location is
 * one of the following:
 * - `VariableMemoryLocation` - A location within a known `IRVariable`, at an offset that is either a constant or is
 * unknown.
 * - `UnknownMemoryLocation` - A location not known to be within a specific `IRVariable`.
 *
 * Some of these memory locations will be filtered out for performance reasons before being passed to SSA construction.
 */
abstract private class MemoryLocation0 extends TMemoryLocation {
  final string toString() {
    if this.isMayAccess()
    then result = "?" + this.toStringInternal()
    else result = this.toStringInternal()
  }

  abstract string toStringInternal();

  abstract VirtualVariable getVirtualVariable();

  abstract Language::LanguageType getType();

  abstract string getUniqueId();

  abstract IRFunction getIRFunction();

  abstract Location getLocation();

  final IRType getIRType() { result = this.getType().getIRType() }

  abstract predicate isMayAccess();

  /**
   * Gets an allocation associated with this `MemoryLocation`.
   *
   * This returns zero or one results in all cases except when `this` is an
   * instance of `GroupedMemoryLocation`. When `this` is an instance of
   * `GroupedMemoryLocation` this predicate always returns two or more results.
   */
  Allocation getAnAllocation() { none() }

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

  final predicate canReuseSsa() { none() }
}

/**
 * Represents a set of `MemoryLocation`s that cannot overlap with
 * `MemoryLocation`s outside of the set. The `VirtualVariable` will be
 * represented by a `MemoryLocation` that totally overlaps all other
 * `MemoryLocations` in the set.
 */
abstract class VirtualVariable extends MemoryLocation0 { }

abstract class AllocationMemoryLocation extends MemoryLocation0 {
  Allocation var;
  boolean isMayAccess;

  bindingset[isMayAccess]
  AllocationMemoryLocation() { any() }

  final override VirtualVariable getVirtualVariable() {
    if allocationEscapes(var)
    then result = TAllAliasedMemory(var.getEnclosingIRFunction(), false)
    else (
      // It may be that the grouped memory location contains an escaping
      // allocation. In that case, the virtual variable is still the memory
      // location that represents all aliased memory. Thus, we need to
      // call `getVirtualVariable` on the grouped memory location.
      result = getGroupedMemoryLocation(var, false, false).getVirtualVariable()
      or
      not exists(getGroupedMemoryLocation(var, false, false)) and
      result.(AllocationMemoryLocation).getAnAllocation() = var
    )
  }

  final override IRFunction getIRFunction() { result = var.getEnclosingIRFunction() }

  final override Location getLocation() { result = var.getLocation() }

  final override Allocation getAnAllocation() { result = var }

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
    if this.coversEntireVariable()
    then result = ""
    else result = Interval::getIntervalString(startBitOffset, endBitOffset)
  }

  private string getTypeString() {
    if this.coversEntireVariable() and type = var.getIRType()
    then result = ""
    else result = "<" + languageType.toString() + ">"
  }

  final override string toStringInternal() {
    result = var.toString() + this.getIntervalString() + this.getTypeString()
  }

  final override Language::LanguageType getType() {
    if
      strictcount(Language::LanguageType accessType |
        hasResultMemoryAccess(_, _, var, type, accessType, startBitOffset, endBitOffset, _, false) or
        hasOperandMemoryAccess(_, _, var, type, accessType, startBitOffset, endBitOffset, _, false)
      ) = 1
    then
      // All of the accesses have the same `LanguageType`, so just use that.
      hasResultMemoryAccess(_, _, var, type, result, startBitOffset, endBitOffset, _, false) or
      hasOperandMemoryAccess(_, _, var, type, result, startBitOffset, endBitOffset, _, false)
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
  final predicate coversEntireVariable() { this.varIRTypeHasBitRange(startBitOffset, endBitOffset) }

  pragma[noinline]
  private predicate varIRTypeHasBitRange(int start, int end) {
    start = 0 and
    end = var.getIRType().getByteSize() * 8
  }
}

/**
 * A group of allocations represented as a single memory location.
 *
 * If `isAll()` holds then this memory location represents all the enclosing
 * allocations, and if `isSome()` holds then this memory location represents
 * one or more of the enclosing allocations.
 *
 * For example, consider the following snippet:
 * ```
 * int* p;
 * int a, b;
 * if(b) {
 *   p = &a;
 * } else {
 *   p = &b;
 * }
 * *p = 42;
 * ```
 *
 * The write memory location associated with the write to `*p` writes to a
 * grouped memory location representing the _some_ allocation in the set
 * `{a, b}`, and the subsequent `Chi` instruction merges the new value of
 * `{a, b}` into a memory location that represents _all_ of the allocations
 * in the set.
 */
class GroupedMemoryLocation extends TGroupedMemoryLocation, MemoryLocation0 {
  VariableGroup vg;
  boolean isMayAccess;
  boolean isAll;

  GroupedMemoryLocation() { this = TGroupedMemoryLocation(vg, isMayAccess, isAll) }

  final override Location getLocation() { result = vg.getLocation() }

  final override IRFunction getIRFunction() { result = vg.getIRFunction() }

  final override predicate isMayAccess() { isMayAccess = true }

  final override string getUniqueId() {
    if this.isAll()
    then result = "All{" + strictconcat(vg.getAnAllocation().getUniqueId(), ", ") + "}"
    else result = "Some{" + strictconcat(vg.getAnAllocation().getUniqueId(), ", ") + "}"
  }

  final override string toStringInternal() { result = this.getUniqueId() }

  final override Language::LanguageType getType() { result = vg.getType() }

  final override VirtualVariable getVirtualVariable() {
    if allocationEscapes(this.getAnAllocation())
    then result = TAllAliasedMemory(vg.getIRFunction(), false)
    else result = TGroupedMemoryLocation(vg, false, true)
  }

  /** Gets an allocation of this memory location. */
  override Allocation getAnAllocation() { result = vg.getAnAllocation() }

  /** Gets the set of allocations associated with this memory location. */
  VariableGroup getGroup() { result = vg }

  /** Holds if this memory location represents all the enclosing allocations. */
  predicate isAll() { isAll = true }

  /** Holds if this memory location represents one or more of the enclosing allocations. */
  predicate isSome() { isAll = false }
}

private GroupedMemoryLocation getGroupedMemoryLocation(
  Allocation alloc, boolean isMayAccess, boolean isAll
) {
  result.getAnAllocation() = alloc and
  (
    isMayAccess = true and result.isMayAccess()
    or
    isMayAccess = false and not result.isMayAccess()
  ) and
  (
    isAll = true and result.isAll()
    or
    isAll = false and result.isSome()
  )
}

class EntireAllocationMemoryLocation extends TEntireAllocationMemoryLocation,
  AllocationMemoryLocation
{
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
    not this.isMayAccess()
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
    this.coversEntireVariable() and
    not this.isMayAccess()
  }
}

class GroupedVirtualVariable extends GroupedMemoryLocation, VirtualVariable {
  GroupedVirtualVariable() {
    forex(Allocation var | var = this.getAnAllocation() | not allocationEscapes(var)) and
    not this.isMayAccess() and
    this.isAll()
  }
}

/**
 * An access to memory that is not known to be confined to a specific `IRVariable`.
 */
class UnknownMemoryLocation extends TUnknownMemoryLocation, MemoryLocation0 {
  IRFunction irFunc;
  boolean isMayAccess;

  UnknownMemoryLocation() { this = TUnknownMemoryLocation(irFunc, isMayAccess) }

  final override string toStringInternal() { result = "{Unknown}" }

  final override VirtualVariable getVirtualVariable() { result = TAllAliasedMemory(irFunc, false) }

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
class AllNonLocalMemory extends TAllNonLocalMemory, MemoryLocation0 {
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

  override predicate canDefineReadOnly() {
    // A "must" access that defines all non-local memory appears only on the `InitializeNonLocal`
    // instruction, which provides the initial definition for all memory outside of the current
    // function's stack frame. This memory includes string literals and other read-only globals, so
    // we allow such an access to be the definition for a use of a read-only location.
    not this.isMayAccess()
  }
}

/**
 * An access to all aliased memory.
 */
class AllAliasedMemory extends TAllAliasedMemory, MemoryLocation0 {
  IRFunction irFunc;
  boolean isMayAccess;

  AllAliasedMemory() { this = TAllAliasedMemory(irFunc, isMayAccess) }

  final override string toStringInternal() { result = "{AllAliased}" }

  final override Language::LanguageType getType() {
    result = any(IRUnknownType type).getCanonicalLanguageType()
  }

  final override IRFunction getIRFunction() { result = irFunc }

  final override Location getLocation() { result = irFunc.getLocation() }

  final override string getUniqueId() { result = " " + this.toString() }

  final override VirtualVariable getVirtualVariable() { result = TAllAliasedMemory(irFunc, false) }

  final override predicate isMayAccess() { isMayAccess = true }
}

/** A virtual variable that groups all escaped memory within a function. */
class AliasedVirtualVariable extends AllAliasedMemory, VirtualVariable {
  AliasedVirtualVariable() { not this.isMayAccess() }
}

/**
 * Gets the overlap relationship between the definition location `def` and the use location `use`.
 */
Overlap getOverlap(MemoryLocation0 def, MemoryLocation0 use) {
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
private Overlap getExtentOverlap(MemoryLocation0 def, MemoryLocation0 use) {
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
      // EntireAllocationMemoryLocation exactly overlaps any EntireAllocationMemoryLocation for the
      // same allocation. Checking the allocation, rather than the memory location itself, ensures
      // that we get the right relationship between the "must" and "may" memory locations for that
      // allocation.
      // Note that if one of the locations is a "may" access, the overlap will be downgraded to
      // `MustTotallyOverlap` or `MayPartialOverlap` in `getOverlap()`.
      use.(EntireAllocationMemoryLocation).getAnAllocation() = def.getAnAllocation() and
      result instanceof MustExactlyOverlap
      or
      not use instanceof EntireAllocationMemoryLocation and
      if def.getAnAllocation() = use.getAnAllocation()
      then
        // EntireAllocationMemoryLocation totally overlaps any location within
        // the same allocation.
        result instanceof MustTotallyOverlap
      else (
        // There is no overlap with a location that's known to belong to a
        // different allocation, but all other locations may partially overlap.
        not exists(use.getAnAllocation()) and
        result instanceof MayPartiallyOverlap
      )
    )
    or
    exists(GroupedMemoryLocation group |
      group = def and
      def.getVirtualVariable() = use.getVirtualVariable()
    |
      (
        use instanceof UnknownMemoryLocation or
        use instanceof AllAliasedMemory
      ) and
      result instanceof MayPartiallyOverlap
      or
      group.isAll() and
      (
        group.getAnAllocation() =
          [
            use.(EntireAllocationMemoryLocation).getAnAllocation(),
            use.(VariableMemoryLocation).getAnAllocation()
          ]
        or
        use.(GroupedMemoryLocation).isSome()
      ) and
      result instanceof MustTotallyOverlap
      or
      group.isAll() and
      use.(GroupedMemoryLocation).isAll() and
      result instanceof MustExactlyOverlap
      or
      group.isSome() and
      (
        use instanceof EntireAllocationMemoryLocation
        or
        use instanceof VariableMemoryLocation
        or
        use instanceof GroupedMemoryLocation
      ) and
      result instanceof MayPartiallyOverlap
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
          use instanceof EntireAllocationMemoryLocation or
          use instanceof GroupedMemoryLocation
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
    var = vml.getAnAllocation() and
    vvar = vml.getVirtualVariable() and
    isRelatableMemoryLocation(vml) and
    offsetRank in [startRank .. endRank]
  )
}

private predicate hasUnknownOffset(Allocation var, VariableMemoryLocation vml) {
  vml.getAnAllocation() = var and
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
  hasUnknownOffset(use.getAnAllocation(), def)
  or
  hasUnknownOffset(def.getAnAllocation(), use)
}

private Overlap getVariableMemoryLocationOverlap(
  VariableMemoryLocation def, VariableMemoryLocation use
) {
  overlappingIRVariableMemoryLocations(def, use) and
  result =
    Interval::getOverlap(def.getStartBitOffset(), def.getEndBitOffset(), use.getStartBitOffset(),
      use.getEndBitOffset())
}

/**
 * Holds if the def/use information for the result of `instr` can be reused from the previous
 * iteration of the IR.
 */
predicate canReuseSsaForOldResult(Instruction instr) { OldSsa::canReuseSsaForMemoryResult(instr) }

bindingset[result, b]
private boolean unbindBool(boolean b) { result != b.booleanNot() }

/** Gets the number of overlapping uses of `def`. */
private int numberOfOverlappingUses(MemoryLocation0 def) {
  result = strictcount(MemoryLocation0 use | exists(getOverlap(def, use)))
}

/**
 * Holds if `def` is a busy definition. That is, it has a large number of
 * overlapping uses.
 */
private predicate isBusyDef(MemoryLocation0 def) { numberOfOverlappingUses(def) > 1024 }

/** Holds if `use` is a use that overlaps with a busy definition. */
private predicate useOverlapWithBusyDef(MemoryLocation0 use) {
  exists(MemoryLocation0 def |
    exists(getOverlap(def, use)) and
    isBusyDef(def)
  )
}

final private class FinalMemoryLocation = MemoryLocation0;

/**
 * A memory location accessed by a memory operand or memory result. In this implementation, the location is
 * one of the following:
 * - `VariableMemoryLocation` - A location within a known `IRVariable`, at an offset that is either a constant or is
 * unknown.
 * - `UnknownMemoryLocation` - A location not known to be within a specific `IRVariable`.
 *
 * Compared to `MemoryLocation0`, this class does not contain memory locations that represent uses of busy definitions.
 */
class MemoryLocation extends FinalMemoryLocation {
  MemoryLocation() { not useOverlapWithBusyDef(this) }
}

bindingset[fun]
pragma[inline_late]
private MemoryLocation getUnknownMemoryLocation(IRFunction fun, boolean isMayAccess) {
  result = TUnknownMemoryLocation(fun, isMayAccess)
}

bindingset[fun]
pragma[inline_late]
private MemoryLocation getAllAliasedMemory(IRFunction fun, boolean isMayAccess) {
  result = TAllAliasedMemory(fun, isMayAccess)
}

bindingset[fun]
pragma[inline_late]
private MemoryLocation getAllNonLocalMemory(IRFunction fun, boolean isMayAccess) {
  result = TAllNonLocalMemory(fun, isMayAccess)
}

MemoryLocation getResultMemoryLocation(Instruction instr) {
  not canReuseSsaForOldResult(instr) and
  exists(MemoryAccessKind kind, boolean isMayAccess |
    kind = instr.getResultMemoryAccess() and
    (if instr.hasResultMayMemoryAccess() then isMayAccess = true else isMayAccess = false) and
    (
      (
        isIndirectOrBufferMemoryAccess(kind) and
        if hasResultMemoryAccess(_, instr, _, _, _, _, _, _, _)
        then
          exists(
            Allocation var, IRType type, IntValue startBitOffset, IntValue endBitOffset,
            boolean grouped
          |
            hasResultMemoryAccess(_, instr, var, type, _, startBitOffset, endBitOffset, isMayAccess,
              grouped)
          |
            // If the instruction is only associated with one allocation we assign it a `VariableMemoryLocation`
            if grouped = false
            then
              result =
                TVariableMemoryLocation(var, type, _, startBitOffset, endBitOffset,
                  unbindBool(isMayAccess))
            else
              // And otherwise we assign it a memory location that groups all the relevant memory locations into one.
              result = getGroupedMemoryLocation(var, unbindBool(isMayAccess), false)
          )
        else result = getUnknownMemoryLocation(instr.getEnclosingIRFunction(), isMayAccess)
      )
      or
      kind instanceof EntireAllocationMemoryAccess and
      result =
        TEntireAllocationMemoryLocation(getAddressOperandAllocation(instr.getResultAddressOperand()),
          unbindBool(isMayAccess))
      or
      kind instanceof EscapedMemoryAccess and
      result = getAllAliasedMemory(instr.getEnclosingIRFunction(), isMayAccess)
      or
      kind instanceof NonLocalMemoryAccess and
      result = getAllNonLocalMemory(instr.getEnclosingIRFunction(), isMayAccess)
    )
  )
}

private MemoryLocation0 getOperandMemoryLocation0(MemoryOperand operand, boolean isMayAccess) {
  not canReuseSsaForOldResult(operand.getAnyDef()) and
  exists(MemoryAccessKind kind |
    kind = operand.getMemoryAccess() and
    (if operand.hasMayReadMemoryAccess() then isMayAccess = true else isMayAccess = false) and
    (
      (
        isIndirectOrBufferMemoryAccess(kind) and
        if hasOperandMemoryAccess(_, operand, _, _, _, _, _, _, _)
        then
          exists(
            Allocation var, IRType type, IntValue startBitOffset, IntValue endBitOffset,
            boolean grouped
          |
            hasOperandMemoryAccess(_, operand, var, type, _, startBitOffset, endBitOffset,
              isMayAccess, grouped)
          |
            // If the operand is only associated with one memory location we assign it a `VariableMemoryLocation`
            if grouped = false
            then
              result =
                TVariableMemoryLocation(var, type, _, startBitOffset, endBitOffset, isMayAccess)
            else
              // And otherwise we assign it a memory location that groups all relevant memory locations into one.
              result = getGroupedMemoryLocation(var, isMayAccess, false)
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
      result = TAllAliasedMemory(operand.getEnclosingIRFunction(), isMayAccess)
      or
      kind instanceof NonLocalMemoryAccess and
      result = TAllNonLocalMemory(operand.getEnclosingIRFunction(), isMayAccess)
    )
  )
}

MemoryLocation getOperandMemoryLocation(MemoryOperand operand) {
  exists(MemoryLocation0 use0, boolean isMayAccess |
    use0 = getOperandMemoryLocation0(operand, isMayAccess)
  |
    result = use0
    or
    // If `use0` overlaps with a busy definition we turn it into a use
    // of `UnknownMemoryLocation`.
    not use0 instanceof MemoryLocation and
    result = TUnknownMemoryLocation(operand.getEnclosingIRFunction(), isMayAccess)
  )
}

/** Gets the start bit offset of a `MemoryLocation`, if any. */
int getStartBitOffset(VariableMemoryLocation location) {
  result = location.getStartBitOffset() and Ints::hasValue(result)
}

/** Gets the end bit offset of a `MemoryLocation`, if any. */
int getEndBitOffset(VariableMemoryLocation location) {
  result = location.getEndBitOffset() and Ints::hasValue(result)
}
