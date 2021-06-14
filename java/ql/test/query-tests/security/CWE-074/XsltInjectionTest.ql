import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XsltInjection
import TestUtilities.InlineExpectationsTest

class Conf extends TaintTracking::Configuration {
  Conf() { this = "test:cwe:xslt-injection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XsltInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(XsltInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

class HasXsltInjectionTest extends InlineExpectationsTest {
  HasXsltInjectionTest() { this = "HasXsltInjectionTest" }

  override string getARelevantTag() { result = "hasXsltInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasXsltInjection" and
    exists(DataFlow::Node src, DataFlow::Node sink, Conf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
