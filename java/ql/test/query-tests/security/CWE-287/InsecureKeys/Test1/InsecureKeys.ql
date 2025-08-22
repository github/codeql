import java
import utils.test.InlineExpectationsTest
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.AndroidLocalAuthQuery

module InsecureKeysTest implements TestSig {
  string getARelevantTag() { result = "insecure-key" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "insecure-key" and
    exists(InsecureBiometricKeyParamCall call | usesLocalAuth() |
      call.getLocation() = location and
      element = call.toString() and
      value = ""
    )
  }
}

import MakeTest<InsecureKeysTest>
