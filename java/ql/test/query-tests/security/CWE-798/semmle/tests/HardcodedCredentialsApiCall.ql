import java
import semmle.code.java.security.HardcodedCredentialsApiCallQuery
import TestUtilities.InlineExpectationsTest

class HardcodedCredentialsApiCallTest extends InlineExpectationsTest {
  HardcodedCredentialsApiCallTest() { this = "HardcodedCredentialsApiCallTest" }

  override string getARelevantTag() { result = "HardcodedCredentialsApiCall" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "HardcodedCredentialsApiCall" and
    exists(DataFlow::Node sink | HardcodedCredentialApiCallFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
