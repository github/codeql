import java
import utils.test.InlineExpectationsTest
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.AndroidLocalAuthQuery

module InsecureAuthTest implements TestSig {
  string getARelevantTag() { result = "insecure-auth" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "insecure-auth" and
    exists(AuthenticationSuccessCallback cb | not exists(cb.getAResultUse()) |
      cb.getLocation() = location and
      element = cb.toString() and
      value = ""
    )
  }
}

import MakeTest<InsecureAuthTest>
