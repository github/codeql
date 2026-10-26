import cpp
import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysis
import semmle.code.cpp.rangeanalysis.new.internal.semantic.Semantic
import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExprSpecific
import semmle.code.cpp.ir.IR as IR
import utils.test.InlineExpectationsTest

module RangeAnalysisTest implements TestSig {
  string getARelevantTag() { result = "range" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(SemExpr e, IR::CallInstruction call |
      getSemanticExpr(call.getArgument(0)) = e and
      call.getStaticCallTarget().hasName("range") and
      tag = "range" and
      element = e.toString() and
      location = e.getLocation() and
      value = quote(getARangeString(e))
    )
  }
}

import MakeTest<RangeAnalysisTest>

private string getDirectionString(boolean d) {
  result = "<=" and d = true
  or
  result = ">=" and d = false
}

bindingset[value]
private string getOffsetString(float value) {
  if value >= 0 then result = "+" + value.toString() else result = value.toString()
}

bindingset[s]
string quote(string s) { if s.matches("% %") then result = "\"" + s + "\"" else result = s }

bindingset[delta]
private string getBoundString(SemBound b, float delta) {
  b instanceof SemZeroBound and result = delta.toString()
  or
  result = strictconcat(b.(SemSsaBound).getAVariable().toString(), " | ") + getOffsetString(delta)
}

private string getARangeString(SemExpr e) {
  exists(SemBound b, float delta, boolean upper |
    semBounded(e, b, delta, upper, _) and
    if semBounded(e, b, delta, upper.booleanNot(), _)
    then delta != 0 and result = "==" + getBoundString(b, delta)
    else result = getDirectionString(upper) + getBoundString(b, delta)
  )
}
