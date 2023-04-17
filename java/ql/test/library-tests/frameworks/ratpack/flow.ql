import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineExpectationsTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("taint")
    or
    n instanceof RemoteFlowSource
  }

  predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }
}

module Flow = TaintTracking::Global<Config>;

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = "hasTaintFlow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasTaintFlow" and
    exists(DataFlow::Node sink | Flow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
