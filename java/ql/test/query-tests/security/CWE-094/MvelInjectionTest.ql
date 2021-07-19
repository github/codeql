import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.MvelInjectionQuery
import TestUtilities.InlineExpectationsTest

class HasMvelInjectionTest extends InlineExpectationsTest {
  HasMvelInjectionTest() { this = "HasMvelInjectionTest" }

  override string getARelevantTag() { result = "hasMvelInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasMvelInjection" and
    exists(DataFlow::Node src, DataFlow::Node sink, MvelInjectionFlowConfig conf |
      conf.hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
