private import cpp
import AliasAnalysis
import semmle.code.cpp.ir.internal.Overlap
private import semmle.code.cpp.Print
private import semmle.code.cpp.ir.implementation.unaliased_ssa.IR
private import semmle.code.cpp.ir.internal.IntegerConstant as Ints
private import semmle.code.cpp.ir.internal.IntegerInterval as Interval
private import semmle.code.cpp.ir.implementation.internal.OperandTag

private class IntValue = Ints::IntValue;

private predicate hasResultMemoryAccess(Instruction instr, IRVariable var, Type type, IntValue startBitOffset,
    IntValue endBitOffset) {
  resultPointsTo(instr.getResultAddress(), var, startBitOffset) and
  type = instr.getResultType() and
  if exists(instr.getResultSize()) then
    endBitOffset = Ints::add(startBitOffset, Ints::mul(instr.getResultSize(), 8))
  else
    endBitOffset = Ints::unknown()
}

private predicate hasOperandMemoryAccess(MemoryOperand operand, IRVariable var, Type type, IntValue startBitOffset,
    IntValue endBitOffset) {
  resultPointsTo(operand.getAddressOperand().getAnyDef(), var, startBitOffset) and
  type = operand.getType() and
  if exists(operand.getSize()) then
    endBitOffset = Ints::add(startBitOffset, Ints::mul(operand.getSize(), 8))
  else
    endBitOffset = Ints::unknown()
}

private newtype TMemoryLocation =
  TVariableMemoryLocation(IRVariable var, Type type, IntValue startBitOffset, IntValue endBitOffset) {
    hasResultMemoryAccess(_, var, type, startBitOffset, endBitOffset) or
    hasOperandMemoryAccess(_, var, type, startBitOffset, endBitOffset)
  }
  or
  TUnknownMemoryLocation(IRFunction irFunc) or
  TUnknownVirtualVariable(IRFunction irFunc)

/**
 * Represents the memory location accessed by a memory operand or memory result. In this implementation, the location is
 * one of the following:
 * - `VariableMemoryLocation` - A location within a known `IRVariable`, at an offset that is either a constant or is
 * unknown.
 * - `UnknownMemoryLocation` - A location not known to be within a specific `IRVariable`.
 */
abstract class MemoryLocation extends TMemoryLocation {
  abstract string toString();
  
  abstract VirtualVariable getVirtualVariable();

  abstract Type getType();

  abstract string getUniqueId();
}

abstract class VirtualVariable extends MemoryLocation {
}

/**
 * An access to memory within a single known `IRVariable`. The variable may be either an unescaped variable
 * (with its own `VirtualIRVariable`) or an escaped variable (assigned to `UnknownVirtualVariable`).
 */
class VariableMemoryLocation extends TVariableMemoryLocation, MemoryLocation {
  IRVariable var;
  Type type;
  IntValue startBitOffset;
  IntValue endBitOffset;

  VariableMemoryLocation() {
    this = TVariableMemoryLocation(var, type, startBitOffset, endBitOffset)
  }

  override final string toString() {
    result = var.toString() + Interval::getIntervalString(startBitOffset, endBitOffset) + "<" + type.toString() + ">"
  }

  override final Type getType() {
    result = type
  }

  final IntValue getStartBitOffset() {
    result = startBitOffset
  }
  
  final IntValue getEndBitOffset() {
    result = endBitOffset
  }
  
  final IRVariable getVariable() {
    result = var
  }

  override final string getUniqueId() {
    result = var.getUniqueId() + Interval::getIntervalString(startBitOffset, endBitOffset) + "<" +
      getTypeIdentityString(type) + ">"
  }

  override final VirtualVariable getVirtualVariable() {
    if variableAddressEscapes(var) then
      result = TUnknownVirtualVariable(var.getEnclosingIRFunction())
    else
      result = TVariableMemoryLocation(var, var.getType(), 0, var.getType().getSize() * 8)
  }

  /**
   * Holds if this memory location covers the entire variable.
   */
  final predicate coversEntireVariable() {
    startBitOffset = 0 and
    endBitOffset = var.getType().getSize() * 8
  }
}

/**
 * Represents the `MemoryLocation` for an `IRVariable` that acts as its own `VirtualVariable`. Includes any
 * `VariableMemoryLocation` that exactly overlaps its entire `IRVariable`, and only if that `IRVariable` does not
 * escape.
 */
class VariableVirtualVariable extends VariableMemoryLocation, VirtualVariable {
  VariableVirtualVariable() {
    not variableAddressEscapes(var) and
    type = var.getType() and
    coversEntireVariable()
  }
}

/**
 * An access to memory that is not known to be confined to a specific `IRVariable`.
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
    exists(VariableMemoryLocation defVariableLocation |
      defVariableLocation = def and
      (
        (
          // A VariableMemoryLocation may partially overlap an unknown location within the same virtual variable.
          def.getVirtualVariable() = use.getVirtualVariable() and
          ((use instanceof UnknownMemoryLocation) or (use instanceof UnknownVirtualVariable)) and
          result instanceof MayPartiallyOverlap
        ) or
        // A VariableMemoryLocation overlaps another location within the same variable based on the relationship
        // of the two offset intervals.
        exists(Overlap intervalOverlap |
          intervalOverlap = getVariableMemoryLocationOverlap(def, use) and
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
          else if defVariableLocation.coversEntireVariable() then (
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
  exists(VariableMemoryLocation ml |
    ml.getVirtualVariable() = vv
    |
    ml.getStartBitOffset() = offset
    or
    ml.getEndBitOffset() = offset
  )
}

private predicate isRelatableMemoryLocation(VariableMemoryLocation vml) {
  vml.getEndBitOffset() != Ints::unknown() and
  vml.getStartBitOffset() != Ints::unknown()
}

private predicate isCoveredOffset(VariableMemoryLocation vml, VirtualVariable vv, int offsetRank) {
  exists(int startRank, int endRank |
    vml.getStartBitOffset() = rank[startRank](IntValue offset_ | isRelevantOffset(vv, offset_)) and
    vml.getEndBitOffset() = rank[endRank](IntValue offset_ | isRelevantOffset(vv, offset_)) and
    vv = vml.getVirtualVariable() and
    isRelatableMemoryLocation(vml) and
    offsetRank in [startRank .. endRank]
  )
}

private predicate hasUnknownOffset(VariableMemoryLocation vml, VirtualVariable vv) {
  vml.getVirtualVariable() = vv and
  (
    vml.getStartBitOffset() = Ints::unknown() or
    vml.getEndBitOffset() = Ints::unknown()
  )
}

private predicate overlappingVariableMemoryLocations(VariableMemoryLocation def, VariableMemoryLocation use) {
    exists(VirtualVariable vv, int offsetRank | isCoveredOffset(def, vv, offsetRank) and isCoveredOffset(use, vv, offsetRank))
    or
    hasUnknownOffset(def, use.getVirtualVariable())
    or
    hasUnknownOffset(use, def.getVirtualVariable())
}

pragma[noopt] // Internal ticket: QL-937
private predicate overlappingIRVariableMemoryLocations(VariableMemoryLocation def, VariableMemoryLocation use) {
  overlappingVariableMemoryLocations(def, use) and
  def.getVariable() = use.getVariable()
}

private Overlap getVariableMemoryLocationOverlap(VariableMemoryLocation def, VariableMemoryLocation use) {
  overlappingIRVariableMemoryLocations(def, use) and
  result = Interval::getOverlap(def.getStartBitOffset(), def.getEndBitOffset(), use.getStartBitOffset(), use.getEndBitOffset())
}


MemoryLocation getResultMemoryLocation(Instruction instr) {
  exists(MemoryAccessKind kind |
    kind = instr.getResultMemoryAccess() and
    (
      (
        kind.usesAddressOperand() and
        if hasResultMemoryAccess(instr, _, _, _, _) then (
          exists(IRVariable var, Type type, IntValue startBitOffset, IntValue endBitOffset |
            hasResultMemoryAccess(instr, var, type, startBitOffset, endBitOffset) and
            result = TVariableMemoryLocation(var, type, startBitOffset, endBitOffset)
          )
        )
        else (
          result = TUnknownMemoryLocation(instr.getEnclosingIRFunction())
        )
      ) or
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
  exists(MemoryAccessKind kind |
    kind = operand.getMemoryAccess() and
    (
      (
        kind.usesAddressOperand() and
        if hasOperandMemoryAccess(operand, _, _, _, _) then (
          exists(IRVariable var, Type type, IntValue startBitOffset, IntValue endBitOffset |
            hasOperandMemoryAccess(operand, var, type, startBitOffset, endBitOffset) and
            result = TVariableMemoryLocation(var, type, startBitOffset, endBitOffset)
          )
        )
        else (
          result = TUnknownMemoryLocation(operand.getEnclosingIRFunction())
        )
      ) or
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
