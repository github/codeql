import cpp

private import semmle.code.cpp.ir.IR
// TODO: move this dependency
import semmle.code.cpp.ir.internal.IntegerConstant

// TODO: move this out of test code
language[monotonicAggregates]
IntValue getConstantValue(Instruction instr) {
  result = instr.(IntegerConstantInstruction).getValue().toInt() or
  exists(BinaryInstruction binInstr, IntValue left, IntValue right |
    binInstr = instr and
    left = getConstantValue(binInstr.getLeftOperand()) and
    right = getConstantValue(binInstr.getRightOperand()) and
    (
      binInstr instanceof AddInstruction and result = add(left, right) or
      binInstr instanceof SubInstruction and result = sub(left, right) or
      binInstr instanceof MulInstruction and result = mul(left, right) or
      binInstr instanceof DivInstruction and result = div(left, right)
    )
  ) or
  result = getConstantValue(instr.(CopyInstruction).getSourceValue()) or
  exists(PhiInstruction phi |
    phi = instr and
    result = max(PhiOperand operand | operand = phi.getAnOperand() | getConstantValue(operand.getDefinitionInstruction())) and
    result = min(PhiOperand operand | operand = phi.getAnOperand() | getConstantValue(operand.getDefinitionInstruction()))
  )
}

predicate valueFlowStep(Instruction i, Operand op, int delta) {
  i.getAnOperand().(CopySourceOperand) = op and delta = 0
  or
  exists(Operand x |
    i.(AddInstruction).getAnOperand() = op and
    i.(AddInstruction).getAnOperand() = x and
    op  != x
    |
    delta = getValue(getConstantValue(x.getDefinitionInstruction()))
  )
  or
  exists(Operand x |
    i.(SubInstruction).getAnOperand().(LeftOperand) = op and
    i.(SubInstruction).getAnOperand().(RightOperand) = x
    |
    delta = -getValue(getConstantValue(x.getDefinitionInstruction()))
  )
  or
  exists(Operand x |
    i.(PointerAddInstruction).getAnOperand() = op and
    i.(PointerAddInstruction).getAnOperand() = x and
    op  != x
    |
    delta = i.(PointerAddInstruction).getElementSize() *
      getValue(getConstantValue(x.getDefinitionInstruction()))
  )
  or
  exists(Operand x |
    i.(PointerSubInstruction).getAnOperand().(LeftOperand) = op and
    i.(PointerSubInstruction).getAnOperand().(RightOperand) = x
    |
    delta = i.(PointerSubInstruction).getElementSize() * 
      -getValue(getConstantValue(x.getDefinitionInstruction()))
  )
}

predicate backEdge(PhiInstruction phi, PhiOperand op) {
  phi.getAnOperand() = op and
  phi.getBlock() = op.getPredecessorBlock().getBackEdgeSuccessor(_)
}
