import python
import Resources.FileNotAlwaysClosedQuery
import utils.test.InlineExpectationsTest

module MethodArgTest implements TestSig {
  string getARelevantTag() { result = ["notClosed", "notClosedOnException"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::CfgNode el, FileOpen fo |
      el = fo and
      element = el.toString() and
      location = el.getLocation() and
      value = "" and
      (
        fileNotClosed(fo) and
        tag = "notClosed"
        or
        fileMayNotBeClosedOnException(fo, _) and
        tag = "notClosedOnException"
      )
    )
  }
}

import MakeTest<MethodArgTest>
