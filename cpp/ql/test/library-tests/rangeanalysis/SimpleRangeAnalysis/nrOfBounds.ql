import cpp
import utils.test.InlineExpectationsTest
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

query predicate estimateNrOfBounds(Expr e, float nrOfBounds) {
  nrOfBounds = SimpleRangeAnalysisInternal::estimateNrOfBounds(e)
}

/**
 * Finds any expressions for which `nrOfBounds` is not functional. The result
 * should be empty, so this predicate is useful to debug non-functional cases.
 */
private predicate nonFunctionalNrOfBounds(Expr e) {
  strictcount(SimpleRangeAnalysisInternal::estimateNrOfBounds(e)) > 1
}

module FunctionalityTest implements TestSig {
  string getARelevantTag() { result = "nonFunctionalNrOfBounds" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Expr e |
      nonFunctionalNrOfBounds(e) and
      location = e.getLocation() and
      element = e.toString() and
      tag = "nonFunctionalNrOfBounds" and
      value = ""
    )
  }
}

import MakeTest<FunctionalityTest>
