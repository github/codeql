import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.GroovyInjectionQuery
import TestUtilities.InlineExpectationsTest

class HasGroovyInjectionTest extends InlineExpectationsTest {
  HasGroovyInjectionTest() { this = "HasGroovyInjectionTest" }

  override string getARelevantTag() { result = "hasGroovyInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasGroovyInjection" and
    exists(DataFlow::Node sink | GroovyInjectionFlow::hasFlowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
