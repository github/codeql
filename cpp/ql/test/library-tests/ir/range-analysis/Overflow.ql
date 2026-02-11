import cpp
import semmle.code.cpp.rangeanalysis.new.SimpleRangeAnalysis
import utils.test.InlineExpectationsTest

module RangeAnalysisTest implements TestSig {
  string getARelevantTag() { result = "overflow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Expr e |
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

import MakeTest<RangeAnalysisTest>
