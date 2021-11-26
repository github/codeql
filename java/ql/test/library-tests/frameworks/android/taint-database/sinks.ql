import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.QueryInjection
import TestUtilities.InlineExpectationsTest

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:dataflow:android::flow" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(MethodAccess).getMethod().hasName("taint")
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }
}

class SinkTest extends InlineExpectationsTest {
  SinkTest() { this = "SinkTest" }

  override string getARelevantTag() { result = "taintReachesSink" }

  override predicate hasActualResult(Location l, string element, string tag, string value) {
    tag = "taintReachesSink" and
    value = "" and
    exists(Conf conf, DataFlow::Node source, DataFlow::Node sink |
      conf.hasFlow(source, sink) and
      l = source.getLocation() and
      element = source.toString()
    )
  }
}
