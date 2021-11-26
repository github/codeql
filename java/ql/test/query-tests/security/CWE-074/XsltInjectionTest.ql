import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XsltInjectionQuery
import TestUtilities.InlineExpectationsTest

class HasXsltInjectionTest extends InlineExpectationsTest {
  HasXsltInjectionTest() { this = "HasXsltInjectionTest" }

  override string getARelevantTag() { result = "hasXsltInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasXsltInjection" and
    exists(DataFlow::Node src, DataFlow::Node sink, XsltInjectionFlowConfig conf |
      conf.hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
