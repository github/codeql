import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.QueryInjection
import TestUtilities.InlineExpectationsTest

private module QueryInjectionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    src.asExpr() = any(MethodAccess ma | ma.getMethod().hasName("source"))
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.getType() instanceof NumberType
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(AdditionalQueryInjectionTaintStep s).step(node1, node2)
  }
}

private module QueryInjectionFlow = TaintTracking::Global<QueryInjectionFlowConfig>;

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = "sqlInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "sqlInjection" and
    exists(DataFlow::Node sink | QueryInjectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
