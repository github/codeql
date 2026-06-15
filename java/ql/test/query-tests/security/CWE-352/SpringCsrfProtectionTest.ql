import java
import semmle.code.java.security.SpringCsrfProtection
import utils.test.InlineExpectationsTest

module SpringCsrfProtectionTest implements TestSig {
  string getARelevantTag() { result = "hasSpringCsrfProtectionDisabled" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasSpringCsrfProtectionDisabled" and
    exists(MethodCall call | disablesSpringCsrfProtection(call) |
      call.getLocation() = location and
      element = call.toString() and
      value = ""
    )
  }
}

import MakeTest<SpringCsrfProtectionTest>
