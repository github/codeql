import cpp
import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.ModulusAnalysis
import semmle.code.cpp.rangeanalysis.new.internal.semantic.Semantic
import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeUtils
import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.FloatDelta
import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysisRelativeSpecific
import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysisImpl
import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExprSpecific
import semmle.code.cpp.ir.IR as IR
import TestUtilities.InlineExpectationsTest

module ModulusAnalysisInstantiated =
  ModulusAnalysis<FloatDelta, ConstantBounds, RangeUtil<FloatDelta, CppLangImplRelative>>;

module ModulusAnalysisTest implements TestSig {
  string getARelevantTag() { result = "mod" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(SemExpr e, IR::CallInstruction call |
      getSemanticExpr(call.getArgument(0)) = e and
      call.getStaticCallTarget().hasName("mod") and
      tag = "mod" and
      element = e.toString() and
      location = e.getLocation() and
      value = getAModString(e)
    )
  }
}

import MakeTest<ModulusAnalysisTest>

private string getAModString(SemExpr e) {
  exists(SemBound b, int delta, int mod |
    ModulusAnalysisInstantiated::semExprModulus(e, b, delta, mod) and
    result = b.toString() + "," + delta.toString() + "," + mod.toString() and
    not (delta = 0 and mod = 0)
  )
}
