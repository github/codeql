/**
 * @kind graph
 */

import semmle.code.cpp.ir.PrintIR
import semmle.code.cpp.ir.IR as IR
import experimental.semmle.code.cpp.semantic.analysis.SignAnalysisCommon
import experimental.semmle.code.cpp.semantic.Semantic

class SignProvider extends IR::IRPropertyProvider {
  override string getInstructionProperty(IR::Instruction instruction, string key) {
    key = "sign" and
    result = concat(semExprSign(instruction).toString(), "")
  }
}
