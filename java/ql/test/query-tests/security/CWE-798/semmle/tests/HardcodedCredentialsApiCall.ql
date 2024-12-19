import java
import semmle.code.java.security.HardcodedCredentialsApiCallQuery
import utils.test.InlineExpectationsTest

module HardcodedCredentialsApiCallTest implements TestSig {
  string getARelevantTag() { result = "HardcodedCredentialsApiCall" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "HardcodedCredentialsApiCall" and
    exists(DataFlow::Node sink | HardcodedCredentialApiCallFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HardcodedCredentialsApiCallTest>
