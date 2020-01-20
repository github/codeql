import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.ir.internal.CppType
private import semmle.code.cpp.models.interfaces.Allocation
private import RangeUtils
import Bound

// general TODO how do we handle stores of tracked arrays in ptrs, structs, ...
// TODO accept more expressions and ignore safe casts
private predicate parseAllocationSizeExpr(Expr expr, int sizeof, Expr elements) {
  expr instanceof MulExpr and
  exists(SizeofOperator sizeofOp |
    expr.(MulExpr).getAnOperand() = sizeofOp and
    expr.(MulExpr).getAnOperand() = elements and
    sizeofOp != elements and
    sizeof = sizeofOp.getValue().toInt()
  )
  or
  // TODO restrict this to upcasts
  expr instanceof Conversion and
  parseAllocationSizeExpr(expr.(Conversion).getExpr(), sizeof, elements)
}

cached
module ArrayLengthAnalysisCached {
  /**
   * Holds if the allocation expression `alloc` allocates `length`+`delta` elements of
   * size `elementSize`
   */
  // TODO new[] handling is complicated by the fact that it can both allocate array of
  // TODO what about casts, and converted vs. unconverted expressions?
  // Do we need to worry about safe casts here?
  cached
  predicate boundedAllocationExpr(AllocationExpr alloc, int elementSize, Length length, int delta) {
    // new, so we know 1 element of known size
    elementSize = alloc.(NewExpr).getAllocatedType().getSize() and
    length instanceof ZeroLength and
    delta = 1
    or
    // malloc(5), so we assume typesize=1
    alloc.getSizeMult() = 1 and
    length instanceof ZeroLength and
    alloc.getSizeExpr().getValue().toInt() = delta and
    not alloc.getSizeExpr().getAChild*() instanceof SizeofOperator and
    elementSize = 1
    or
    // malloc(5*sizeof(Type))
    exists(Expr multiplier |
      alloc.getSizeMult() = 1 and
      parseAllocationSizeExpr(alloc.getSizeExpr(), elementSize, multiplier) and
      multiplier.getValue().toInt() = delta and
      length instanceof ZeroLength
    )
    or
    // malloc(count*sizeof(Type))
    exists(Expr multiplier |
      alloc.getSizeMult() = 1 and
      parseAllocationSizeExpr(alloc.getSizeExpr(), elementSize, multiplier) and
      length.(VNLength).getInstruction().getConvertedResultExpression() = multiplier and
      delta = 0
    )
    or
    // malloc(count) (no sizeof!)
    not alloc.getSizeExpr().getAChild*() instanceof SizeofOperator and
    alloc.getSizeMult() = 1 and
    not exists(int d | d = alloc.getSizeExpr().getValue().toInt()) and
    length.(VNLength).getInstruction().getConvertedResultExpression() = alloc.getSizeExpr() and
    elementSize = 1 and
    delta = 0
  }

  /**
   * Holds if the instruction `i` is due to an allocation of `bound`+`delta` elements.
   */
  cached
  predicate boundedAllocation(Instruction i, Length length, int delta) {
    exists(AllocationExpr alloc, int elementSize |
      i.getUnconvertedResultExpression() = alloc and
      (
        // select the instruction that includes the cast to the non-void* type after the malloc
        // But only if there is a cast available to do so
        count(Instruction i2 | i2.getUnconvertedResultExpression() = alloc) = 1 or
        not exists(VoidPointerType typ | i.getResultLanguageType().hasType(typ, false))
      ) and
      // ensure that the element size discovered by the logic below matches the size of the
      // pointed-to elements
      exists(PointerType ptrTyp |
        i.getResultLanguageType().hasType(ptrTyp, false) and
        elementSize = ptrTyp.getBaseType().getSize()
        or
        ptrTyp instanceof VoidPointerType and
        elementSize = 1
      ) and
      boundedAllocationExpr(alloc, elementSize, length, delta)
    )
  }

  /**
   * Holds if array is declared as an array with length delta
   */
  cached
  predicate arrayDeclaration(Instruction array, Length length, int delta) {
    (
      array instanceof VariableAddressInstruction or
      array instanceof FieldAddressInstruction
    ) and
    exists(ArrayType type | array.getResultLanguageType().hasType(type, _) |
      length instanceof ZeroLength and
      delta = type.getArraySize()
    )
  }
}

module InterproceduralRangeAnalysis {
  private predicate getParameterFromArg(
    Instruction arg, IRFunction callee, InitializeParameterInstruction param
  ) {
    exists(int index, CallInstruction call |
      callee = param.getEnclosingIRFunction() and
      call.getPositionalArgument(index) = arg and
      param.getParameter() = callee.getFunction().getParameter(index)
    )
  }

  /**
   * Holds if the length of array is bounded by b + delta in the context of being called
   * by `call`.
   */
  cached
  private predicate boundedArrayLengthInCallContext(CallInstruction call, Instruction array, Bound b) {
    exists(Instruction arrayArg, Bound boundArg, IRFunction callee, Instruction boundParam |
      // TODO why exactly do we need to go to the AST here? That doesn't really make sense imho
      callee.getFunction() = call.getStaticCallTarget() and
      // TODO re-enable once API redesign is complete
      //boundedArrayLength(arrayArg, boundArg, delta) and
      // translate array from caller to callee
      getParameterFromArg(arrayArg, callee, array) and
      // translate array length from caller to callee
      // TODO include constant integer offsets in count and array pointer in delta
      (
        boundArg instanceof ZeroBound and
        b instanceof ZeroBound
        or
        getParameterFromArg(boundArg.getInstruction(), callee, boundParam) and
        b.getInstruction() = boundParam
      )
    )
  }

  // PRECISE bound for function parameters
  // TODO does not take Virtual Dispatch into account, so not precise :-|
  cached
  predicate boundedArrayLengthParameter(InitializeParameterInstruction array, Bound b) {
    forex(CallInstruction call | call.getStaticCallTarget() = array.getEnclosingFunction() |
      boundedArrayLengthInCallContext(call, array, b)
    )
  }
}

private import ArrayLengthAnalysisCached
private import InterproceduralRangeAnalysis

private int getBaseSizeForPointerType(PointerType type) { result = type.getBaseType().getSize() }

/**
 * Holds if array has bound + delta elements available to the right or left,
 * given that the array source has length sourceBound+sourceDelta (to the right or left).
 * TODO pointer add with variable (more complicated, but possible if input is zerobound!)
 * TODO pointer casts with different sizes (conservative estimation of #elements)
 */
bindingset[prevOffsetDelta]
private predicate simpleArrayLengthStep(
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
    then toTyp.getBaseType().getSize() = 1
    else getBaseSizeForPointerType(fromTyp) = getBaseSizeForPointerType(toTyp)
  )
}

private newtype TLength =
  TZeroLength() or
  TVNLength(ValueNumber vn) {
    exists(Instruction i |
      vn.getAnInstruction() = i and
      (
        i.getResultIRType() instanceof IRSignedIntegerType or
        i.getResultIRType() instanceof IRUnsignedIntegerType
      )
    ) and
    not vn.getAnInstruction() instanceof ConstantInstruction
  }

/**
 * TODO docstring
 */
abstract class Length extends TLength {
  abstract string toString();
}

/**
 * TODO docstring
 */
class ZeroLength extends Length, TZeroLength {
  override string toString() { result = "ZeroLength" }
}

/**
 * TODO docstring
 */
class VNLength extends Length, TVNLength {
  ValueNumber vn;

  VNLength() { this = TVNLength(vn) }

  /** Gets the SSA variable that equals value number bound. */
  Instruction getInstruction() { this = TVNLength(valueNumber(result)) }

  ValueNumber getValueNumber() { result = vn }

  override string toString() { result = vn.getExampleInstruction().toString() }
}

private newtype TOffset =
  TZeroOffset() or
  TOpOffset(Operand op) {
    op.getAnyDef().getResultIRType() instanceof IRSignedIntegerType or
    op.getAnyDef().getResultIRType() instanceof IRUnsignedIntegerType
  }

/**
 * TODO docstring
 */
abstract class Offset extends TOffset {
  abstract string toString();
}

/**
 * TODO docstring
 */
class ZeroOffset extends Offset, TZeroOffset {
  override string toString() { result = "ZeroOffset" }
}

/**
 * TODO docstring
 */
class OpOffset extends Offset, TOpOffset {
  Operand op;

  OpOffset() { this = TOpOffset(op) }

  Operand getOperand() { result = op }

  override string toString() { result = op.toString() }
}

/**
 * Holds if the instruction `array` represents a pointer to a chunk of memory that holds
 * `length + lengthDelta` elements.
 * `array` points at `offset` in the chunk of memory.
 * It is in-bounds if offset < bound+delta and offset >= 0.
 */
cached
predicate boundedArrayLength(
  Instruction array, Length length, int lengthDelta, Offset offset, int offsetDelta
) {
  // TODO deallocation should result in a zero-bound
  boundedAllocation(array, length, lengthDelta) and
  offset instanceof ZeroOffset and
  offsetDelta = 0
  or
  // declaration of variable of array type
  arrayDeclaration(array, length, lengthDelta) and
  offset instanceof ZeroOffset and
  offsetDelta = 0
  or
  // interprocedurally derived bound on parameter
  //boundedArrayLengthParameter(array, bound, delta, right)
  //or
  // simple step (no phi nodes)
  exists(Instruction prev, Offset prevOffset, int prevOffsetDelta |
    boundedArrayLength(prev, length, lengthDelta, prevOffset, prevOffsetDelta) and
    simpleArrayLengthStep(array, offset, offsetDelta, prev, prevOffset, prevOffsetDelta)
  )
  or
  // merge control flow after phi node - but only if all the bounds agree (quite unlikely case)
  forex(Instruction input | array.(PhiInstruction).getAnInput() = input |
    boundedArrayLength(input, length, lengthDelta, offset, offsetDelta)
  )
}
