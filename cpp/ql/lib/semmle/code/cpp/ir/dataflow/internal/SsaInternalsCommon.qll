import cpp as Cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.internal.IRCppLanguage

predicate ignoreOperand(Operand operand) {
  operand = any(Instruction instr | ignoreInstruction(instr)).getAnOperand()
}

predicate ignoreInstruction(Instruction instr) {
  instr instanceof WriteSideEffectInstruction or
  instr instanceof PhiInstruction or
  instr instanceof ReadSideEffectInstruction or
  instr instanceof ChiInstruction or
  instr instanceof InitializeIndirectionInstruction
}

bindingset[isGLValue]
private CppType getThisType(Cpp::MemberFunction f, boolean isGLValue) {
  result.hasType(f.getTypeOfThis(), isGLValue)
}

cached
CppType getResultLanguageType(Instruction i) {
  if i.(VariableAddressInstruction).getIRVariable() instanceof IRThisVariable
  then
    if i.isGLValue()
    then result = getThisType(i.getEnclosingFunction(), true)
    else result = getThisType(i.getEnclosingFunction(), false)
  else result = i.getResultLanguageType()
}

CppType getLanguageType(Operand operand) {
  result = getResultLanguageType(operand.getDef())
}
