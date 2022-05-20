import java
import semmle.code.java.security.ConditionalBypassQuery
import TestUtilities.InlineExpectationsTest

class ConditionalBypassTest extends InlineExpectationsTest {
  ConditionalBypassTest() { this = "ConditionalBypassTest" }

  override string getARelevantTag() { result = "hasConditionalBypassTest" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasConditionalBypassTest" and
    exists(DataFlow::Node src, DataFlow::Node sink, ConditionalBypassFlowConfig conf |
      conf.hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
