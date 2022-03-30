import csharp
private import experimental.ir.IR
// TODO: move this dependency
import experimental.ir.internal.IntegerConstant

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

/**
 * Gets the dimension of the array (either the declared size, or the
 * size of the initializer); if no size is declared and no initializer used,
 * the predicate does not hold.
 */
IntValue getArrayDim(Variable arr) {
  exists(ArrayCreation ac |
    arr.getInitializer() = ac and
    if exists(ac.getLengthArgument(0))
    then result = ac.getLengthArgument(0).getValue().toInt()
    else result = ac.getInitializer().getNumberOfElements()
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
