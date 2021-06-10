import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.GroovyInjection
import TestUtilities.InlineExpectationsTest

class Conf extends TaintTracking::Configuration {
  Conf() { this = "test:cwe:groovy-injection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof GroovyInjectionSink }

  override predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    any(GroovyInjectionAdditionalTaintStep c).step(fromNode, toNode)
  }
}

class HasGroovyInjectionTest extends InlineExpectationsTest {
  HasGroovyInjectionTest() { this = "HasGroovyInjectionTest" }

  override string getARelevantTag() { result = "hasGroovyInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasGroovyInjection" and
    exists(DataFlow::Node src, DataFlow::Node sink, Conf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
