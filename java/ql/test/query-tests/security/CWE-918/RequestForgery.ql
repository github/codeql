import java
import semmle.code.java.security.RequestForgeryConfig
import TestUtilities.InlineExpectationsTest

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = "SSRF" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "SSRF" and
    exists(RequestForgeryConfiguration conf, DataFlow::Node sink | conf.hasFlowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
