import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XSS
import TestUtilities.InlineExpectationsTest

class XssConfig extends TaintTracking::Configuration {
  XssConfig() { this = "XSSConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XssSink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof XssSanitizer }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(XssAdditionalTaintStep s).step(node1, node2)
  }
}

class XssTest extends InlineExpectationsTest {
  XssTest() { this = "XssTest" }

  override string getARelevantTag() { result = "xss" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "xss" and
    exists(DataFlow::Node src, DataFlow::Node sink, XssConfig conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
