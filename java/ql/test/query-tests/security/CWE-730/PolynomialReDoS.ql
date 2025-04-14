import utils.test.InlineExpectationsTest
import semmle.code.java.security.regexp.PolynomialReDoSQuery

module HasPolyRedos implements TestSig {
  string getARelevantTag() { result = "hasPolyRedos" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasPolyRedos" and
    exists(DataFlow::Node sink |
      PolynomialRedosFlow::flowTo(sink) and
      location = sink.getLocation() and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HasPolyRedos>
