import cpp
import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.SignAnalysisCommon
import semmle.code.cpp.rangeanalysis.new.internal.semantic.Semantic
import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeUtils
import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.FloatDelta
import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysisRelativeSpecific
import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExprSpecific
import semmle.code.cpp.ir.IR as IR
import TestUtilities.InlineExpectationsTest

module SignAnalysisInstantiated =
  SignAnalysis<FloatDelta, RangeUtil<FloatDelta, CppLangImplRelative>>;

module SignAnalysisTest implements TestSig {
  string getARelevantTag() { result = "sign" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(SemExpr e, IR::CallInstruction call |
      getSemanticExpr(call.getArgument(0)) = e and
      call.getStaticCallTarget().hasName("sign") and
      tag = "sign" and
      element = e.toString() and
      location = e.getLocation() and
      value = getASignString(e)
    )
  }
}

import MakeTest<SignAnalysisTest>

private string getASignString(SemExpr e) {
  result = strictconcat(SignAnalysisInstantiated::semExprSign(e).toString(), "")
}
