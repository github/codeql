import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.OgnlInjection
import TestUtilities.InlineExpectationsTest

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:cwe:ognl-injection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof OgnlInjectionSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(OgnlInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

class OgnlInjectionTest extends InlineExpectationsTest {
  OgnlInjectionTest() { this = "HasOgnlInjection" }

  override string getARelevantTag() { result = "hasOgnlInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasOgnlInjection" and
    exists(DataFlow::Node src, DataFlow::Node sink, Conf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
