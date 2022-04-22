import cpp
import experimental.semmle.code.cpp.semantic.analysis.ModulusAnalysis
import experimental.semmle.code.cpp.semantic.Semantic
import semmle.code.cpp.ir.IR as IR
import TestUtilities.InlineExpectationsTest

class ModulusAnalysisTest extends InlineExpectationsTest {
  ModulusAnalysisTest() { this = "ModulusAnalysisTest" }

  override string getARelevantTag() { result = "mod" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(SemExpr e, IR::CallInstruction call |
      call.getArgument(0) = e and
      call.getStaticCallTarget().hasName("mod") and
      tag = "mod" and
      element = e.toString() and
      location = e.getLocation() and
      value = getAModString(e)
    )
  }
}

private string getAModString(SemExpr e) {
  exists(SemBound b, int delta, int mod |
    semExprModulus(e, b, delta, mod) and
    result = b.toString() + "," + delta.toString() + "," + mod.toString() and
    not (delta = 0 and mod = 0)
  )
}
