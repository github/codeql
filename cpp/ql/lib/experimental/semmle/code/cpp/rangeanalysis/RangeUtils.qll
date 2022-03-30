import cpp
private import semmle.code.cpp.ir.IR
// TODO: move this dependency
import semmle.code.cpp.ir.internal.IntegerConstant

// TODO: move this out of test code
language[monotonicAggregates]
IntValue getConstantValue(Instruction instr) {
  result = instr.(IntegerConstantInstruction).getValue().toInt()
  or
  exists(BinaryInstruction binInstr, IntValue left, IntValue right |
    binInstr = instr and
    left = getConstantValue(binInstr.getLeft()) and
    right = getConstantValue(binInstr.getRight()) and
    (
      binInstr instanceof AddInstruction and result = add(left, right)
      or
      binInstr instanceof SubInstruction and result = sub(left, right)
      or
      binInstr instanceof MulInstruction and result = mul(left, right)
      or
      binInstr instanceof DivInstruction and result = div(left, right)
    )
  )
  or
  result = getConstantValue(instr.(CopyInstruction).getSourceValue())
  or
  exists(PhiInstruction phi |
    phi = instr and
    result =
      max(PhiInputOperand operand |
        operand = phi.getAnOperand()
      |
        getConstantValue(operand.getDef())
      ) and
    result =
      min(PhiInputOperand operand |
        operand = phi.getAnOperand()
      |
        getConstantValue(operand.getDef())
      )
  )
}

predicate valueFlowStep(Instruction i, Operand op, int delta) {
  i.(CopyInstruction).getSourceValueOperand() = op and delta = 0
  or
  exists(Operand x |
    i.(AddInstruction).getAnOperand() = op and
    i.(AddInstruction).getAnOperand() = x and
    op != x
  |
    delta = getValue(getConstantValue(x.getDef()))
  )
  or
  exists(Operand x |
    i.(SubInstruction).getLeftOperand() = op and
    i.(SubInstruction).getRightOperand() = x
  |
    delta = -getValue(getConstantValue(x.getDef()))
  )
  or
  exists(Operand x |
    i.(PointerAddInstruction).getAnOperand() = op and
    i.(PointerAddInstruction).getAnOperand() = x and
    op != x
  |
    delta = i.(PointerAddInstruction).getElementSize() * getValue(getConstantValue(x.getDef()))
  )
  or
  exists(Operand x |
    i.(PointerSubInstruction).getLeftOperand() = op and
    i.(PointerSubInstruction).getRightOperand() = x
  |
    delta = i.(PointerSubInstruction).getElementSize() * -getValue(getConstantValue(x.getDef()))
  )
}

predicate backEdge(PhiInstruction phi, PhiInputOperand op) {
  phi.getAnOperand() = op and
  phi.getBlock() = op.getPredecessorBlock().getBackEdgeSuccessor(_)
}

/**
 * Holds if a cast from `fromtyp` to `totyp` can be ignored for the purpose of
 * range analysis.
 */
pragma[inline]
private predicate safeCast(IRIntegerType fromtyp, IRIntegerType totyp) {
  fromtyp.getByteSize() < totyp.getByteSize() and
  (
    fromtyp.isUnsigned()
    or
    totyp.isSigned()
  )
  or
  fromtyp.getByteSize() <= totyp.getByteSize() and
  (
    fromtyp.isSigned() and
    totyp.isSigned()
    or
    fromtyp.isUnsigned() and
    totyp.isUnsigned()
  )
}

/**
 * A `ConvertInstruction` which casts from one pointer type to another.
 */
class PtrToPtrCastInstruction extends ConvertInstruction {
  PtrToPtrCastInstruction() {
    getResultIRType() instanceof IRAddressType and
    getUnary().getResultIRType() instanceof IRAddressType
  }
}

/**
 * A `ConvertInstruction` which casts from one integer type to another in a way
 * that cannot overflow or underflow.
 */
class SafeIntCastInstruction extends ConvertInstruction {
  SafeIntCastInstruction() { safeCast(getUnary().getResultIRType(), getResultIRType()) }
}

/**
 * A `ConvertInstruction` which does not invalidate bounds determined by
 * range analysis.
 */
class SafeCastInstruction extends ConvertInstruction {
  SafeCastInstruction() {
    this instanceof PtrToPtrCastInstruction or
    this instanceof SafeIntCastInstruction
  }
}
