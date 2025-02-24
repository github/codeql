import python 
import Resources.FileNotAlwaysClosedQuery
import utils.test.InlineExpectationsTest

module MethodArgTest implements TestSig {
  string getARelevantTag() { result = "notAlwaysClosed" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::CfgNode f |
      element = f.toString() and
      location = f.getLocation() and
      value = "" and
      (
        fileNotAlwaysClosed(f) and
        tag = "notAlwaysClosed"
      )
    )
  }
}

import MakeTest<MethodArgTest>