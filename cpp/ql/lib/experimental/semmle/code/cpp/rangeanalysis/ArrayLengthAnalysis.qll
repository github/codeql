/**
 * Provides precise tracking of how big the memory pointed to by pointers is.
 * For each pointer, we start tracking (starting from the allocation or an array declaration)
 * 1) how long is the chunk of memory allocated
 * 2) where the current pointer is in this chunk of memory
 * As computing this information is obviously not possible for all pointers,
 * we do not guarantee the existence of length/offset information for all pointers.
 * However, when it exists it is guaranteed to be accurate.
 *
 * The  length and offset are tracked in a similar way to the Rangeanalysis.
 * Each length is a `ValueNumber + delta`, and each Offset is an `Operand + delta`.
 * We choose to track a `ValueNumber` for length, because the Rangeanalysis offers
 * integer bounds on instructions and operands in terms of `ValueNumber`s,
 * and `Operand` for offset because integer bounds on `Operand`s are
 * tighter than bounds on `Instruction`s.
 */

import cpp
import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.ir.internal.CppType
private import semmle.code.cpp.models.interfaces.Allocation
private import experimental.semmle.code.cpp.rangeanalysis.RangeUtils

private newtype TLength =
  TZeroLength() or
  TVNLength(ValueNumber vn) {
    not vn.getAnInstruction() instanceof ConstantInstruction and
    exists(Instruction i |
      vn.getAnInstruction() = i and
      (
        i.getResultIRType() instanceof IRSignedIntegerType or
        i.getResultIRType() instanceof IRUnsignedIntegerType
      )
    |
      i instanceof PhiInstruction
      or
      i instanceof InitializeParameterInstruction
      or
      i instanceof CallInstruction
      or
      i.(LoadInstruction).getSourceAddress() instanceof VariableAddressInstruction
      or
      i.(LoadInstruction).getSourceAddress() instanceof FieldAddressInstruction
      or
      i.getAUse() instanceof ArgumentOperand
    )
  }

/**
 * Array lengths are represented in a ValueNumber | Zero + delta format.
 * This class keeps track of the ValueNumber or Zero.
 * The delta is tracked in the predicate `knownArrayLength`.
 */
class Length extends TLength {
  string toString() { none() } // overridden in subclasses
}

/**
 * This length class corresponds to an array having a constant length
 * that is tracked by the delta value.
 */
class ZeroLength extends Length, TZeroLength {
  override string toString() { result = "ZeroLength" }
}

/**
 * This length class corresponds to an array having variable length, i.e. the
 * length is tracked by a value number. One example is an array having length
 * `count` for an integer variable `count` in the program.
 */
class VNLength extends Length, TVNLength {
  ValueNumber vn;

  VNLength() { this = TVNLength(vn) }

  /** Gets an instruction with this value number bound. */
  Instruction getInstruction() { this = TVNLength(valueNumber(result)) }

  ValueNumber getValueNumber() { result = vn }

  override string toString() { result = "VNLength(" + vn.getExampleInstruction().toString() + ")" }
}

private newtype TOffset =
  TZeroOffset() or
  TOpOffset(Operand op) {
    op.getAnyDef().getResultIRType() instanceof IRSignedIntegerType or
    op.getAnyDef().getResultIRType() instanceof IRUnsignedIntegerType
  }

/**
 * This class describes the offset of a pointer in a chunk of memory.
 * It is either an `Operand` or zero, an additional integer delta is added later.
 */
class Offset extends TOffset {
  string toString() { none() } // overridden in subclasses
}

/**
 * This class represents a fixed offset, only specified by a delta.
 */
class ZeroOffset extends Offset, TZeroOffset {
  override string toString() { result = "ZeroOffset" }
}

/**
 * This class represents an offset of an operand.
 */
class OpOffset extends Offset, TOpOffset {
  Operand op;

  OpOffset() { this = TOpOffset(op) }

  Operand getOperand() { result = op }

  override string toString() { result = "OpOffset(" + op.getDef().toString() + ")" }
}

private int getBaseSizeForPointerType(PointerType type) { result = type.getBaseType().getSize() }

/**
 * Holds if pointer `prev` that points at offset `prevOffset + prevOffsetDelta`
 * steps to `array` that points to `offset + offsetDelta` in one step.
 * This predicate does not contain any recursive steps.
 */
bindingset[prevOffset, prevOffsetDelta]
predicate simpleArrayLengthStep(
  Instruction array, Offset offset, int offsetDelta, Instruction prev, Offset prevOffset,
  int prevOffsetDelta
) {
  // array assign
  array.(CopyInstruction).getSourceValue() = prev and
  offset = prevOffset and
  offsetDelta = prevOffsetDelta
  or
  // pointer add with constant
  array.(PointerAddInstruction).getLeft() = prev and
  offset = prevOffset and
  offsetDelta = prevOffsetDelta + getConstantValue(array.(PointerAddInstruction).getRight())
  or
  // pointer add with variable
  array.(PointerAddInstruction).getLeft() = prev and
  prevOffset instanceof ZeroOffset and
  offset.(OpOffset).getOperand() = array.(PointerAddInstruction).getRightOperand() and
  offsetDelta = prevOffsetDelta and
  not exists(getConstantValue(array.(PointerAddInstruction).getRight()))
  or
  // pointer sub with constant
  array.(PointerSubInstruction).getLeft() = prev and
  offset = prevOffset and
  offsetDelta = prevOffsetDelta - getConstantValue(array.(PointerSubInstruction).getRight())
  or
  // array to pointer decay
  array.(ConvertInstruction).getUnary() = prev and
  array.getConvertedResultExpression() instanceof ArrayToPointerConversion and
  offset = prevOffset and
  offsetDelta = prevOffsetDelta
  or
  // cast of pointer to pointer with the same element size
  exists(PointerType fromTyp, PointerType toTyp |
    array.(PtrToPtrCastInstruction).getUnary() = prev and
    prev.getResultLanguageType().hasType(fromTyp, false) and
    array.getResultLanguageType().hasType(toTyp, false) and
    offset = prevOffset and
    offsetDelta = prevOffsetDelta and
    if fromTyp instanceof VoidPointerType
    then getBaseSizeForPointerType(toTyp) = 1
    else (
      if toTyp instanceof VoidPointerType
      then getBaseSizeForPointerType(fromTyp) = 1
      else getBaseSizeForPointerType(toTyp) = getBaseSizeForPointerType(fromTyp)
    )
  )
}

/**
 * Parses a `sizeExpr` of malloc into a variable part (`lengthExpr`) and an integer offset (`delta`).
 */
private predicate deconstructMallocSizeExpr(Expr sizeExpr, Expr lengthExpr, int delta) {
  sizeExpr instanceof AddExpr and
  exists(Expr constantExpr |
    lengthExpr = sizeExpr.(AddExpr).getAnOperand() and
    constantExpr = sizeExpr.(AddExpr).getAnOperand() and
    lengthExpr != constantExpr and
    delta = constantExpr.getValue().toInt()
  )
  or
  sizeExpr instanceof SubExpr and
  exists(Expr constantExpr |
    lengthExpr = sizeExpr.(SubExpr).getLeftOperand() and
    constantExpr = sizeExpr.(SubExpr).getRightOperand() and
    delta = -constantExpr.getValue().toInt()
  )
}

/**
 * Holds if the instruction `array` is a dynamic memory allocation of `length`+`delta` elements.
 */
private predicate allocation(Instruction array, Length length, int delta) {
  exists(AllocationExpr alloc, Type ptrTyp |
    array.getUnconvertedResultExpression() = alloc and
    array.getResultLanguageType().hasType(ptrTyp, false) and
    // ensure that we have the same type of the allocation and the pointer
    ptrTyp.stripTopLevelSpecifiers().(PointerType).getBaseType().getUnspecifiedType() =
      alloc.getAllocatedElementType().getUnspecifiedType() and
    // ensure that the size multiplier of the allocation is the same as the
    // size of the type we are allocating
    alloc.getSizeMult() = getBaseSizeForPointerType(ptrTyp) and
    (
      length instanceof ZeroLength and
      delta = alloc.getSizeExpr().getValue().toInt()
      or
      not exists(alloc.getSizeExpr().getValue().toInt()) and
      (
        exists(Expr lengthExpr |
          deconstructMallocSizeExpr(alloc.getSizeExpr(), lengthExpr, delta) and
          length.(VNLength).getInstruction().getConvertedResultExpression() = lengthExpr
        )
        or
        not exists(int d | deconstructMallocSizeExpr(alloc.getSizeExpr(), _, d)) and
        length.(VNLength).getInstruction().getConvertedResultExpression() = alloc.getSizeExpr() and
        delta = 0
      )
    )
  )
}

/**
 * Holds if `array` is declared as an array with length `length + lengthDelta`
 */
private predicate arrayDeclaration(Instruction array, Length length, int lengthDelta) {
  (
    array instanceof VariableAddressInstruction or
    array instanceof FieldAddressInstruction
  ) and
  exists(ArrayType type | array.getResultLanguageType().hasType(type, _) |
    length instanceof ZeroLength and
    lengthDelta = type.getArraySize()
  )
}

/**
 * Holds if `array` is declared as an array or allocated
 * with length `length + lengthDelta`
 */
predicate arrayAllocationOrDeclaration(Instruction array, Length length, int lengthDelta) {
  allocation(array, length, lengthDelta)
  or
  // declaration of variable of array type
  arrayDeclaration(array, length, lengthDelta)
}

/**
 * Holds if the instruction `array` represents a pointer to a chunk of memory that holds
 * `length + lengthDelta` elements, using only local analysis.
 * `array` points at `offset + offsetDelta` in the chunk of memory.
 * The pointer is in-bounds if `offset + offsetDelta < length + lengthDelta` and
 * `offset + offsetDelta >= 0` holds.
 * The pointer is out-of-bounds if `offset + offsetDelta >= length + lengthDelta`
 * or `offset + offsetDelta < 0` holds.
 * All pointers in this predicate are guaranteed to be non-null,
 * but are not guaranteed to be live.
 */
predicate knownArrayLength(
  Instruction array, Length length, int lengthDelta, Offset offset, int offsetDelta
) {
  arrayAllocationOrDeclaration(array, length, lengthDelta) and
  offset instanceof ZeroOffset and
  offsetDelta = 0
  or
  // simple step (no phi nodes)
  exists(Instruction prev, Offset prevOffset, int prevOffsetDelta |
    knownArrayLength(prev, length, lengthDelta, prevOffset, prevOffsetDelta) and
    simpleArrayLengthStep(array, offset, offsetDelta, prev, prevOffset, prevOffsetDelta)
  )
  or
  // merge control flow after phi node - but only if all the bounds agree
  forex(Instruction input | array.(PhiInstruction).getAnInput() = input |
    knownArrayLength(input, length, lengthDelta, offset, offsetDelta)
  )
}
