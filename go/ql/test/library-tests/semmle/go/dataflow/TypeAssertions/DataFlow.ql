import go
import TestUtilities.InlineExpectationsTest

class Configuration extends DataFlow::Configuration {
  Configuration() { this = "test-configuration" }

  override predicate isSource(DataFlow::Node source) {
    source = any(DataFlow::CallNode c | c.getCalleeName() = "src").getResult(0)
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode c | c.getCalleeName() = "sink").getArgument(0)
  }
}

class DataFlowTest extends InlineExpectationsTest {
  DataFlowTest() { this = "DataFlowTest" }

  override string getARelevantTag() { result = "dataflow" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "dataflow" and
    exists(DataFlow::Node sink | any(Configuration c).hasFlow(_, sink) |
      element = sink.toString() and
      value = sink.toString() and
      sink.hasLocationInfo(file, line, _, _, _)
    )
  }
}
