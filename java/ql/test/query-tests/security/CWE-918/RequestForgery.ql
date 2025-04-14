import java
import semmle.code.java.security.RequestForgeryConfig
import utils.test.InlineExpectationsTest

module HasFlowTest implements TestSig {
  string getARelevantTag() { result = "SSRF" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "SSRF" and
    exists(DataFlow::Node sink |
      RequestForgeryFlow::flowTo(sink) and
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HasFlowTest>
