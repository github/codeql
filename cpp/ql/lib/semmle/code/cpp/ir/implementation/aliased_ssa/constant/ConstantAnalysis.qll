private import internal.ConstantAnalysisInternal
private import semmle.code.cpp.ir.internal.IntegerPartial
private import IR

language[monotonicAggregates]
int getConstantValue(Instruction instr) {
  result = instr.(IntegerConstantInstruction).getValue().toInt()
  or
  result = getBinaryInstructionValue(instr)
  or
  result = neg(getConstantValue(instr.(NegateInstruction).getUnary()))
  or
  result = getConstantValue(instr.(CopyInstruction).getSourceValue())
  or
  getConstantValue(instr.(LogicalNotInstruction).getUnary()) != 0 and
  result = 0
  or
  exists(PhiInstruction phi |
    phi = instr and
    result = unique(Operand op | op = phi.getAnInputOperand() | getConstantValue(op.getDef()))
  )
}

pragma[noinline]
private predicate binaryInstructionOperands(BinaryInstruction instr, int left, int right) {
  left = getConstantValue(instr.getLeft()) and
  right = getConstantValue(instr.getRight())
}

pragma[noinline]
private int getBinaryInstructionValue(BinaryInstruction instr) {
  exists(int left, int right | binaryInstructionOperands(instr, left, right) |
    instr instanceof AddInstruction and result = add(left, right)
    or
    instr instanceof SubInstruction and result = sub(left, right)
    or
    instr instanceof MulInstruction and result = mul(left, right)
    or
    instr instanceof DivInstruction and result = div(left, right)
    or
    instr instanceof BitOrInstruction and result = bitOr(left, right)
    or
    instr instanceof BitAndInstruction and result = bitAnd(left, right)
    or
    instr instanceof BitXorInstruction and result = bitXor(left, right)
    or
    instr instanceof CompareEQInstruction and result = compareEQ(left, right)
    or
    instr instanceof CompareNEInstruction and result = compareNE(left, right)
    or
    instr instanceof CompareLTInstruction and result = compareLT(left, right)
    or
    instr instanceof CompareGTInstruction and result = compareGT(left, right)
    or
    instr instanceof CompareLEInstruction and result = compareLE(left, right)
    or
    instr instanceof CompareGEInstruction and result = compareGE(left, right)
  )
}
