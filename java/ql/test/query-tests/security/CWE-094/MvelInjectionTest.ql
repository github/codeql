import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.MvelInjection
import TestUtilities.InlineExpectationsTest

class Conf extends TaintTracking::Configuration {
  Conf() { this = "test:cwe:mvel-injection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof MvelEvaluationSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof MvelInjectionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(MvelInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

class HasMvelInjectionTest extends InlineExpectationsTest {
  HasMvelInjectionTest() { this = "HasMvelInjectionTest" }

  override string getARelevantTag() { result = "hasMvelInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasMvelInjection" and
    exists(DataFlow::Node src, DataFlow::Node sink, Conf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
