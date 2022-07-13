import cpp
import experimental.semmle.code.cpp.semantic.analysis.RangeAnalysis
import experimental.semmle.code.cpp.semantic.Semantic
import semmle.code.cpp.ir.IR as IR
import TestUtilities.InlineExpectationsTest

class RangeAnalysisTest extends InlineExpectationsTest {
  RangeAnalysisTest() { this = "RangeAnalysisTest" }

  override string getARelevantTag() { result = "range" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(SemExpr e, IR::CallInstruction call |
      call.getArgument(0) = e and
      call.getStaticCallTarget().hasName("range") and
      tag = "range" and
      element = e.toString() and
      location = e.getLocation() and
      value = getARangeString(e)
    )
  }
}

private string getDirectionString(boolean d) {
  result = "<=" and d = true
  or
  result = ">=" and d = false
}

bindingset[value]
private string getOffsetString(int value) {
  if value >= 0 then result = "+" + value.toString() else result = value.toString()
}

bindingset[delta]
private string getBoundString(SemBound b, int delta) {
  b instanceof SemZeroBound and result = delta.toString()
  or
  result =
    strictconcat(b.(SemSsaBound).getAVariable().(IR::Instruction).getAst().toString(), ":") +
      getOffsetString(delta)
}

private string getARangeString(SemExpr e) {
  exists(SemBound b, int delta, boolean upper |
    semBounded(e, b, delta, upper, _) and
    if semBounded(e, b, delta, upper.booleanNot(), _)
    then delta != 0 and result = "==" + getBoundString(b, delta)
    else result = getDirectionString(upper) + getBoundString(b, delta)
  )
}
