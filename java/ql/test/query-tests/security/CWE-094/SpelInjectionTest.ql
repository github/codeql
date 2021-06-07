import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.SpelInjection
import TestUtilities.InlineExpectationsTest

class Conf extends TaintTracking::Configuration {
  Conf() { this = "test:cwe:spel-injection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SpelExpressionEvaluationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(SpelExpressionInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

class HasSpelInjectionTest extends InlineExpectationsTest {
  HasSpelInjectionTest() { this = "HasSpelInjectionTest" }

  override string getARelevantTag() { result = "hasSpelInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasSpelInjection" and
    exists(DataFlow::Node src, DataFlow::Node sink, Conf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
