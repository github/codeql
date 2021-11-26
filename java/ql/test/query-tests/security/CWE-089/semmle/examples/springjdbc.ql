import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.QueryInjection
import TestUtilities.InlineExpectationsTest

private class QueryInjectionFlowConfig extends TaintTracking::Configuration {
  QueryInjectionFlowConfig() { this = "SqlInjectionLib::QueryInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() = any(MethodAccess ma | ma.getMethod().hasName("source"))
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.getType() instanceof NumberType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(AdditionalQueryInjectionTaintStep s).step(node1, node2)
  }
}

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = "sqlInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "sqlInjection" and
    exists(DataFlow::Node src, DataFlow::Node sink, QueryInjectionFlowConfig conf |
      conf.hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
