private import internal.ConstantAnalysisInternal
private import semmle.code.cpp.ir.internal.IntegerConstant
private import ConstantAnalysis
import IR

private class ConstantAnalysisPropertyProvider extends IRPropertyProvider {
  override string getInstructionProperty(Instruction instr, string key) {
    key = "ConstantValue" and
    result = getValue(getConstantValue(instr)).toString()
  }
}
