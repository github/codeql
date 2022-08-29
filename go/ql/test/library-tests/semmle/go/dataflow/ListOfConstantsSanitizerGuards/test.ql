import go
import TestUtilities.InlineExpectationsTest

class TestConfig extends TaintTracking::Configuration {
  TestConfig() { this = "test config" }

  override predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getTarget().getName() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode c | c.getTarget().getName() = "sink").getAnArgument()
  }
}

class DataFlowTest extends InlineExpectationsTest {
  DataFlowTest() { this = "DataFlowTest" }

  override string getARelevantTag() { result = "dataflow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "dataflow" and
    exists(DataFlow::Node sink | any(TestConfig c).hasFlow(_, sink) |
      element = sink.toString() and
      value = sink.toString() and
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn())
    )
  }
}
