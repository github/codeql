import java
import semmle.code.java.security.InsecureTrustManagerQuery
import TestUtilities.InlineExpectationsTest

class InsecureTrustManagerTest extends InlineExpectationsTest {
  InsecureTrustManagerTest() { this = "InsecureTrustManagerTest" }

  override string getARelevantTag() { result = "hasValueFlow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasValueFlow" and
    exists(DataFlow::Node sink | InsecureTrustManagerFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
