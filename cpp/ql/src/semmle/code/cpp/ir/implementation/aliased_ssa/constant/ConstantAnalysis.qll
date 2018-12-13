private import internal.ConstantAnalysisInternal
import semmle.code.cpp.ir.internal.IntegerConstant
private import IR

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
      binInstr instanceof DivInstruction and result = div(left, right) or
      binInstr instanceof CompareEQInstruction and result = compareEQ(left, right) or
      binInstr instanceof CompareNEInstruction and result = compareNE(left, right) or
      binInstr instanceof CompareLTInstruction and result = compareLT(left, right) or
      binInstr instanceof CompareGTInstruction and result = compareGT(left, right) or
      binInstr instanceof CompareLEInstruction and result = compareLE(left, right) or
      binInstr instanceof CompareGEInstruction and result = compareGE(left, right)
    )
  ) or
  exists(UnaryInstruction unaryInstr, IntValue src |
    unaryInstr = instr and
    src = getConstantValue(unaryInstr.getOperand()) and
    (
      unaryInstr instanceof NegateInstruction and result = neg(src)
    )
  ) or
  result = getConstantValue(instr.(CopyInstruction).getSourceValue()) or
  exists(PhiInstruction phi |
    phi = instr and
    result = max(PhiOperand operand | operand = phi.getAnOperand() | getConstantValue(operand.getDefinitionInstruction())) and
    result = min(PhiOperand operand | operand = phi.getAnOperand() | getConstantValue(operand.getDefinitionInstruction()))
  )
}
