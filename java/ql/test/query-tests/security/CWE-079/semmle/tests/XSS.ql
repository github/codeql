import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XSS
import TestUtilities.InlineExpectationsTest

module XssConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof XssSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof XssSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(XssAdditionalTaintStep s).step(node1, node2)
  }
}

module XssFlow = TaintTracking::Global<XssConfig>;

class XssTest extends InlineExpectationsTest {
  XssTest() { this = "XssTest" }

  override string getARelevantTag() { result = "xss" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "xss" and
    exists(DataFlow::Node sink | XssFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
