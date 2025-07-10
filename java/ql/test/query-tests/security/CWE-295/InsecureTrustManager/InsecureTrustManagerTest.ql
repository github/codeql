import java
import semmle.code.java.security.InsecureTrustManagerQuery
import utils.test.InlineExpectationsTest

module InsecureTrustManagerTest implements TestSig {
  string getARelevantTag() { result = "hasValueFlow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasValueFlow" and
    exists(DataFlow::Node sink | InsecureTrustManagerFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<InsecureTrustManagerTest>
