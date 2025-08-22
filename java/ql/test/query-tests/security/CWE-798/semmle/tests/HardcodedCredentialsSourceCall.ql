import java
import semmle.code.java.security.HardcodedCredentialsSourceCallQuery
import utils.test.InlineExpectationsTest

module HardcodedCredentialsSourceCallTest implements TestSig {
  string getARelevantTag() { result = "HardcodedCredentialsSourceCall" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "HardcodedCredentialsSourceCall" and
    exists(DataFlow::Node sink | HardcodedCredentialSourceCallFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HardcodedCredentialsSourceCallTest>
