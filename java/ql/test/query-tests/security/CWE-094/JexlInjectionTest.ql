import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSteps
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.JexlInjectionQuery
import TestUtilities.InlineExpectationsTest

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:cwe:jexl-injection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JexlEvaluationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(JexlInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

class JexlInjectionTest extends InlineExpectationsTest {
  JexlInjectionTest() { this = "HasJexlInjectionTest" }

  override string getARelevantTag() { result = "hasJexlInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasJexlInjection" and
    exists(DataFlow::Node src, DataFlow::Node sink, Conf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
