import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XPath
import TestUtilities.InlineExpectationsTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof XPathInjectionSink }
}

module Flow = TaintTracking::Global<Config>;

class HasXPathInjectionTest extends InlineExpectationsTest {
  HasXPathInjectionTest() { this = "HasXPathInjectionTest" }

  override string getARelevantTag() { result = "hasXPathInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasXPathInjection" and
    exists(DataFlow::Node sink | Flow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
