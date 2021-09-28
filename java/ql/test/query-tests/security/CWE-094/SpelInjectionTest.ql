import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.SpelInjectionQuery
import TestUtilities.InlineExpectationsTest

class HasSpelInjectionTest extends InlineExpectationsTest {
  HasSpelInjectionTest() { this = "HasSpelInjectionTest" }

  override string getARelevantTag() { result = "hasSpelInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasSpelInjection" and
    exists(DataFlow::Node src, DataFlow::Node sink, SpelInjectionConfig conf |
      conf.hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
