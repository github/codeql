import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.WebviewDebuggingEnabledQuery

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = "hasValueFlow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasValueFlow" and
    exists(DataFlow::Node sink | WebviewDebugEnabledFlow::hasFlowTo(sink) |
      location = sink.getLocation() and
      element = "sink" and
      value = ""
    )
  }
}
