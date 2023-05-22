import java
import semmle.code.java.security.XssQuery
import TestUtilities.InlineExpectationsTest

class XssTest extends InlineExpectationsTest {
  XssTest() { this = "XssTest" }

  override string getARelevantTag() { result = "xss" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "xss" and
    exists(DataFlow::Node sink | XssFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
