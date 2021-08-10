import java
import semmle.code.java.security.OgnlInjectionQuery
import TestUtilities.InlineExpectationsTest

class OgnlInjectionTest extends InlineExpectationsTest {
  OgnlInjectionTest() { this = "HasOgnlInjection" }

  override string getARelevantTag() { result = "hasOgnlInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasOgnlInjection" and
    exists(DataFlow::Node src, DataFlow::Node sink, OgnlInjectionFlowConfig conf |
      conf.hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
