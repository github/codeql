import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XPath
import TestUtilities.InlineExpectationsTest

class HasXPathInjectionTest extends InlineExpectationsTest {
  HasXPathInjectionTest() { this = "HasXPathInjectionTest" }

  override string getARelevantTag() { result = "hasXPathInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasXPathInjection" and
    exists(DataFlow::Node src, DataFlow::Node sink, XPathInjectionConfiguration conf |
      conf.hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
