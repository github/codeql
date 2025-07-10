import java
import semmle.code.java.security.InsecureBasicAuthQuery
import utils.test.InlineExpectationsTest

module HasInsecureBasicAuthTest implements TestSig {
  string getARelevantTag() { result = "hasInsecureBasicAuth" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasInsecureBasicAuth" and
    exists(DataFlow::Node sink | InsecureBasicAuthFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HasInsecureBasicAuthTest>
