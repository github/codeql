import cpp
import experimental.semmle.code.cpp.semantic.analysis.SignAnalysisCommon
import experimental.semmle.code.cpp.semantic.Semantic
import experimental.semmle.code.cpp.semantic.analysis.RangeUtils
import experimental.semmle.code.cpp.semantic.analysis.FloatDelta
import experimental.semmle.code.cpp.semantic.analysis.RangeAnalysisSpecific
import semmle.code.cpp.ir.IR as IR
import TestUtilities.InlineExpectationsTest

module SignAnalysisInstantiated = SignAnalysis<FloatDelta, RangeUtil<FloatDelta, CppLangImpl>>;

class SignAnalysisTest extends InlineExpectationsTest {
  SignAnalysisTest() { this = "SignAnalysisTest" }

  override string getARelevantTag() { result = "sign" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(SemExpr e, IR::CallInstruction call |
      call.getArgument(0) = e and
      call.getStaticCallTarget().hasName("sign") and
      tag = "sign" and
      element = e.toString() and
      location = e.getLocation() and
      value = getASignString(e)
    )
  }
}

private string getASignString(SemExpr e) {
  result = strictconcat(SignAnalysisInstantiated::semExprSign(e).toString(), "")
}
