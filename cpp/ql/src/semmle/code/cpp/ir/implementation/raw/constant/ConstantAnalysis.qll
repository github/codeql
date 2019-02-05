private import internal.ConstantAnalysisInternal
private import semmle.code.cpp.ir.internal.IntegerPartial
private import IR

language[monotonicAggregates]
int getConstantValue(Instruction instr) {
  result = instr.(IntegerConstantInstruction).getValue().toInt() or
  result = getBinaryInstructionValue(instr) or
  exists(UnaryInstruction unaryInstr, int src |
    unaryInstr = instr and
    src = getConstantValue(unaryInstr.getOperand()) and
    (
      unaryInstr instanceof NegateInstruction and result = neg(src)
    )
  ) or
  result = getConstantValue(instr.(CopyInstruction).getSourceValue()) or
  exists(PhiInstruction phi |
    phi = instr and
    result = max(Instruction def | def = phi.getAnOperandDefinitionInstruction() | getConstantValueToPhi(def)) and
    result = min(Instruction def | def = phi.getAnOperandDefinitionInstruction() | getConstantValueToPhi(def))
  )
}

pragma[noinline]
int getConstantValueToPhi(Instruction def) {
  exists(PhiInstruction phi |
    result = getConstantValue(def) and
    def = phi.getAnOperandDefinitionInstruction()
  )
}

pragma[noinline]
private predicate binaryInstructionOperands(BinaryInstruction instr, int left, int right) {
  left = getConstantValue(instr.getLeftOperand()) and
  right = getConstantValue(instr.getRightOperand())
}

pragma[noinline]
private int getBinaryInstructionValue(BinaryInstruction instr) {
  exists(int left, int right |
    binaryInstructionOperands(instr, left, right) and
    (
      instr instanceof AddInstruction and result = add(left, right) or
      instr instanceof SubInstruction and result = sub(left, right) or
      instr instanceof MulInstruction and result = mul(left, right) or
      instr instanceof DivInstruction and result = div(left, right) or
      instr instanceof CompareEQInstruction and result = compareEQ(left, right) or
      instr instanceof CompareNEInstruction and result = compareNE(left, right) or
      instr instanceof CompareLTInstruction and result = compareLT(left, right) or
      instr instanceof CompareGTInstruction and result = compareGT(left, right) or
      instr instanceof CompareLEInstruction and result = compareLE(left, right) or
      instr instanceof CompareGEInstruction and result = compareGE(left, right)
    )
  )
}
