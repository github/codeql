import swift
import DataFlow
import FlowConfig
import TestUtilities.InlineExpectationsTest

class TaintTest extends InlineExpectationsTest {
  TaintTest() { this = "DataFlowTest" }

  override string getARelevantTag() { result = "flow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(TestConfiguration config, Node source, Node sink, Expr sinkExpr |
      config.hasFlow(source, sink) and
      sinkExpr = sink.asExpr() and
      location = sinkExpr.getLocation() and
      element = sinkExpr.toString() and
      tag = "flow" and
      value = source.asExpr().getLocation().getStartLine().toString()
    )
  }
}
