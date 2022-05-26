import go
import TestUtilities.InlineExpectationsTest

class IsBad extends DataFlow::BarrierGuard, DataFlow::CallNode {
  IsBad() { this.getTarget().getName() = "isBad" }

  override predicate checks(Expr e, boolean branch) {
    e = this.getAnArgument().asExpr() and branch = false
  }
}

class TestConfig extends DataFlow::Configuration {
  TestConfig() { this = "test config" }

  override predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getTarget().getName() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode c | c.getTarget().getName() = "sink").getAnArgument()
  }

  override predicate isBarrierGuard(DataFlow::BarrierGuard bg) { bg instanceof IsBad }
}

class DataFlowTest extends InlineExpectationsTest {
  DataFlowTest() { this = "DataFlowTest" }

  override string getARelevantTag() { result = "dataflow" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "dataflow" and
    exists(DataFlow::Node sink | any(TestConfig c).hasFlow(_, sink) |
      element = sink.toString() and
      value = sink.toString() and
      sink.hasLocationInfo(file, line, _, _, _)
    )
  }
}
