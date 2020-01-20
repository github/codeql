import cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.ValueNumbering
import semmle.code.cpp.rangeanalysis.ArrayLengthAnalysis
import semmle.code.cpp.rangeanalysis.RangeAnalysis
import semmle.code.cpp.rangeanalysis.RangeUtils

// TODO better name
private Instruction getAddressInstruction(Operand op) {
  result = getAddressInstruction(op.getDef().(FieldAddressInstruction).getObjectAddressOperand())
  or
  result = op.getDef() and
  not result instanceof FieldAddressInstruction and
  not result instanceof VariableAddressInstruction
}

/**
 * The IR doesn't provide a clean way to get if an instruction dereferences
 * a pointer or not - this.getAnOperand() instanceof AddressOperand
 * or this.getResultMemoryAccess().usesAddressOperand()
 * does not work.
 */
class PointerDereferenceInstruction extends Instruction {
  PointerDereferenceInstruction() {
    exists(getAddressInstruction(this.getAnOperand().(AddressOperand))) and
    (
      this instanceof StoreInstruction
      or
      this instanceof LoadInstruction
    )
  }

  Instruction getAddress() {
    exists(AddressOperand op |
      op = this.getAnOperand() and
      result = getAddressInstruction(op)
    )
  }
}

// TODO think about soundness of this with regard to variable scoping
predicate provablyInBoundsUpper(PointerDereferenceInstruction ptrAccess) {
  exists(Length length, int lengthDelta, Offset offset, int offsetDelta |
    boundedArrayLength(ptrAccess.getAddress(), length, lengthDelta, offset, offsetDelta) and
    // upper bound
    (
      // both offset and length are  only integers
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
        boundedOperand(offset.(OpOffset).getOperand(), any(ZeroBound b), offsetBoundDelta, /* upper */ true, _) and
        // offset <= offsetBoundDelta, so offset + offsetDelta <= offsetDelta + offsetBoundDelta
        // Thus, provably in-bounds if offsetDelta + offsetBoundDelta < lengthDelta
        // as we have length instanceof ZeroLength
        offsetDelta + offsetBoundDelta < lengthDelta
      )
      or
      exists(ValueNumberBound b, int offsetBoundDelta |
        length instanceof VNLength and
        offset instanceof OpOffset and
        b.getValueNumber() = length.(VNLength).getValueNumber() and
        boundedOperand(offset.(OpOffset).getOperand(), b, offsetBoundDelta, /*upper*/ true, _) and
        // this ensures that offset <= length holds
        offsetBoundDelta <= 0 and
        // with that we get that offset + offsetDelta < length offsetBoundDelta + lengthDelta - offsetBoundDelta
        offsetDelta < lengthDelta - offsetBoundDelta
      )
    )
  )
}

// holds if ptr access is in-bounds from the left
// note that arrays of length 0 are treated only as upper-bound violation
predicate provablyInBoundsLower(PointerDereferenceInstruction ptrAccess) {
  exists(Length length, int lengthDelta, Offset offset, int offsetDelta |
    boundedArrayLength(ptrAccess.getAddress(), length, lengthDelta, offset, offsetDelta) and
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
    )
  )
}

predicate provablyInBounds(PointerDereferenceInstruction ptrAccess) {
  provablyInBoundsLower(ptrAccess) and
  provablyInBoundsUpper(ptrAccess)
}
