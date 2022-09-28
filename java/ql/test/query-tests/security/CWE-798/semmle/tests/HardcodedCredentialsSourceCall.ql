import java
import semmle.code.java.security.HardcodedCredentialsSourceCallQuery
import TestUtilities.InlineExpectationsTest

class HardcodedCredentialsSourceCallTest extends InlineExpectationsTest {
  HardcodedCredentialsSourceCallTest() { this = "HardcodedCredentialsSourceCallTest" }

  override string getARelevantTag() { result = "HardcodedCredentialsSourceCall" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "HardcodedCredentialsSourceCall" and
    exists(DataFlow::Node sink, HardcodedCredentialSourceCallConfiguration conf |
      conf.hasFlow(_, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
