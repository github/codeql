import cpp
import utils.test.InlineExpectationsTest
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

query predicate estimateNrOfBounds(
  Expr e, float nrOfBounds, float actualNrOfLowerBounds, float actualNrOfUpperBounds
) {
  nrOfBounds = SimpleRangeAnalysisInternal::estimateNrOfBounds(e) and
  (
    actualNrOfLowerBounds = SimpleRangeAnalysisInternal::countNrOfLowerBounds(e)
    or
    not exists(SimpleRangeAnalysisInternal::countNrOfLowerBounds(e)) and actualNrOfLowerBounds = -1
  ) and
  (
    actualNrOfUpperBounds = SimpleRangeAnalysisInternal::countNrOfUpperBounds(e)
    or
    not exists(SimpleRangeAnalysisInternal::countNrOfUpperBounds(e)) and actualNrOfUpperBounds = -1
  )
}

/**
 * Finds any expressions for which `nrOfBounds` is not functional. The result
 * should be empty, so this predicate is useful to debug non-functional cases.
 */
private predicate nonFunctionalNrOfBounds(Expr e) {
  strictcount(SimpleRangeAnalysisInternal::estimateNrOfBounds(e)) > 1
}

private predicate nrOfBoundsNotEq1(Expr e, int n) {
  e.getFile().getBaseName() = "test_nr_of_bounds.cpp" and
  n = count(SimpleRangeAnalysisInternal::estimateNrOfBounds(e)) and
  n != 1
}

module FunctionalityTest implements TestSig {
  string getARelevantTag() { result = ["nonFunctionalNrOfBounds", "bounds"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Expr e |
      nonFunctionalNrOfBounds(e) and
      location = e.getLocation() and
      element = e.toString() and
      tag = "nonFunctionalNrOfBounds" and
      value = ""
    )
    or
    exists(Expr e, int n |
      nrOfBoundsNotEq1(e, n) and
      location = e.getLocation() and
      element = e.toString() and
      tag = "bounds" and
      value = n.toString()
    )
  }
}

import MakeTest<FunctionalityTest>
