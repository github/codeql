import java
import semmle.code.java.dataflow.TaintTracking
import TestUtilities.InlineExpectationsTest
private import semmle.code.java.dataflow.ExternalFlow

class Config extends TaintTracking::Configuration {
  Config() { this = "Config" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getCallee().getName() = "source"
    or
    sourceNode(n, "kotlinMadFlowTest")
  }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().getName() = "sink"
    or
    sinkNode(n, "kotlinMadFlowTest")
  }
}

class InlineFlowTest extends InlineExpectationsTest {
  InlineFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = "flow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "flow" and
    exists(DataFlow::Node sink, Config c | c.hasFlowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
