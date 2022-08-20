/**
 * Include this module to annotate IR dumps with information computed by `AliasAnalysis.qll`.
 */

private import AliasAnalysisInternal
private import InputIR
private import AliasAnalysisImports
private import AliasAnalysis
private import semmle.code.cpp.ir.internal.IntegerConstant

private class AliasPropertyProvider extends IRPropertyProvider {
  override string getOperandProperty(Operand operand, string key) {
    result = Print::getOperandProperty(operand, key)
  }

  override string getInstructionProperty(Instruction instr, string key) {
    result = Print::getInstructionProperty(instr, key)
  }
}
