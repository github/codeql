/**
 * This library proves that a subset of pointer dereferences in a program are
 * safe, i.e. in-bounds.
 * It does so by first defining what a pointer dereference is (on the IR
 * `Instruction` level), and then using the array length analysis and the range
 * analysis together to prove that some of these pointer dereferences are safe.
 *
 * The analysis is soundy, i.e. it is sound if no undefined behaviour is present
 * in the program.
 * Furthermore, it crucially depends on the soundiness of the range analysis and
 * the array length analysis.
 */

import cpp
private import experimental.semmle.code.cpp.rangeanalysis.ArrayLengthAnalysis
private import experimental.semmle.code.cpp.rangeanalysis.RangeAnalysis

/**
 * Gets the instruction that computes the address of memory that `i` accesses.
 * Only holds if `i` dereferences a pointer, not when the computation of the
 * memory address is constant, or if the address of a local variable is loaded/stored to.
 */
private Instruction getMemoryAddressInstruction(Instruction i) {
  (
    result = i.(FieldAddressInstruction).getObjectAddress() or
    result = i.(LoadInstruction).getSourceAddress() or
    result = i.(StoreInstruction).getDestinationAddress()
  ) and
  not result instanceof FieldAddressInstruction and
  not result instanceof VariableAddressInstruction and
  not result instanceof ConstantValueInstruction
}

/**
 * All instructions that dereference a pointer.
 */
class PointerDereferenceInstruction extends Instruction {
  PointerDereferenceInstruction() { exists(getMemoryAddressInstruction(this)) }

  Instruction getAddress() { result = getMemoryAddressInstruction(this) }
}

/**
 * Holds if `ptrDeref` can be proven to always access allocated memory.
 */
predicate inBounds(PointerDereferenceInstruction ptrDeref) {
  exists(Length length, int lengthDelta, Offset offset, int offsetDelta |
    knownArrayLength(ptrDeref.getAddress(), length, lengthDelta, offset, offsetDelta) and
    // lower bound - note that we treat a pointer that accesses an array of
    // length 0 as on upper-bound violation, but not as a lower-bound violation
    (
      offset instanceof ZeroOffset and
      offsetDelta >= 0
      or
      offset instanceof OpOffset and
      exists(int lowerBoundDelta |
        boundedOperand(offset.(OpOffset).getOperand(), any(ZeroBound b), lowerBoundDelta,
          /*upper*/ false, _) and
        lowerBoundDelta + offsetDelta >= 0
      )
    ) and
    // upper bound
    (
      // both offset and length are only integers
      length instanceof ZeroLength and
      offset instanceof ZeroOffset and
      offsetDelta < lengthDelta
      or
      exists(int lengthBound |
        // array length is variable+integer, and there's a fixed (integer-only)
        // lower bound on the variable, so we can guarantee this access is always in-bounds
        length instanceof VNLength and
        offset instanceof ZeroOffset and
        boundedInstruction(length.(VNLength).getInstruction(), any(ZeroBound b), lengthBound,
          /* upper*/ false, _) and
        offsetDelta < lengthBound + lengthDelta
      )
      or
      exists(int offsetBoundDelta |
        length instanceof ZeroLength and
        offset instanceof OpOffset and
        boundedOperand(offset.(OpOffset).getOperand(), any(ZeroBound b), offsetBoundDelta,
          /* upper */ true, _) and
        // offset <= offsetBoundDelta, so offset + offsetDelta <= offsetDelta + offsetBoundDelta
        // Thus, in-bounds if offsetDelta + offsetBoundDelta < lengthDelta
        // as we have length instanceof ZeroLength
        offsetDelta + offsetBoundDelta < lengthDelta
      )
      or
      exists(ValueNumberBound b, int offsetBoundDelta |
        length instanceof VNLength and
        offset instanceof OpOffset and
        b.getValueNumber() = length.(VNLength).getValueNumber() and
        // It holds that offset <= length + offsetBoundDelta
        boundedOperand(offset.(OpOffset).getOperand(), b, offsetBoundDelta, /*upper*/ true, _) and
        // it also holds that
        offsetDelta < lengthDelta - offsetBoundDelta
        // taking both inequalities together we get
        //    offset <= length + offsetBoundDelta
        // => offset + offsetDelta <= length + offsetBoundDelta + offsetDelta < length + offsetBoundDelta + lengthDelta - offsetBoundDelta
        // as required
      )
    )
  )
}
