/**
 * @kind graph
 */

import semmle.code.cpp.ir.PrintIR
import semmle.code.cpp.ir.IR as IR
import experimental.semmle.code.cpp.semantic.analysis.ModulusAnalysis
import experimental.semmle.code.cpp.semantic.analysis.ConstantAnalysis
import experimental.semmle.code.cpp.semantic.Semantic

class ModulusProvider extends IR::IRPropertyProvider {
  override string getInstructionProperty(IR::Instruction instruction, string key) {
    key = "mod" and
    result =
      concat(string modString |
        exists(SemBound b, int delta, int mod, string branches |
          branches =
            strictconcat(string branch |
              semExprModulus(instruction, b, delta, mod, branch)
            |
              branch, ", "
            ) and
          modString =
            b.toString() + " " + delta.toString() + " " + mod.toString() + " (" + branches + ")"
        )
      |
        modString, ", "
      )
  }
}
