import cpp
import experimental.semmle.code.cpp.semantic.analysis.SimpleRangeAnalysis
import TestUtilities.InlineExpectationsTest

class RangeAnalysisTest extends InlineExpectationsTest {
  RangeAnalysisTest() { this = "RangeAnalysisTest" }

  override string getARelevantTag() { result = "overflow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Expr e |
      /*call.getArgument(0) = e and
      call.getTarget().hasName("range") and*/
      tag = "overflow" and
      element = e.toString() and
      location = e.getLocation() and
      value =
        strictconcat(string s |
          s = "+" and exprMightOverflowPositively(e)
          or
          s = "-" and exprMightOverflowNegatively(e)
        )
    )
  }
}
