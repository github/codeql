import java
import semmle.code.java.security.XssQuery
import utils.test.InlineExpectationsTest

module XssTest implements TestSig {
  string getARelevantTag() { result = "xss" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "xss" and
    exists(DataFlow::Node sink | XssFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<XssTest>
