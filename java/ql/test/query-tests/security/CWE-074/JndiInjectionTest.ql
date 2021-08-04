import java
import semmle.code.java.security.JndiInjectionQuery
import TestUtilities.InlineExpectationsTest

class HasJndiInjectionTest extends InlineExpectationsTest {
  HasJndiInjectionTest() { this = "HasJndiInjectionTest" }

  override string getARelevantTag() { result = "hasJndiInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasJndiInjection" and
    exists(DataFlow::Node src, DataFlow::Node sink, JndiInjectionFlowConfig conf |
      conf.hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
