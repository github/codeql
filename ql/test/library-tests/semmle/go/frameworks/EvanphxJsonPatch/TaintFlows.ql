import go
import TestUtilities.InlineExpectationsTest

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "test-configuration" }

  override predicate isSource(DataFlow::Node source) {
    source =
      any(DataFlow::CallNode c | c.getCalleeName() in ["getTaintedByteArray", "getTaintedPatch"])
          .getResult(0)
  }

  override predicate isSink(DataFlow::Node sink) {
    sink =
      any(DataFlow::CallNode c | c.getCalleeName() in ["sinkByteArray", "sinkPatch"]).getArgument(0)
  }
}

class TaintFlowTest extends InlineExpectationsTest {
  TaintFlowTest() { this = "TaintFlowTest" }

  override string getARelevantTag() { result = "taintflow" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "taintflow" and
    exists(DataFlow::Node sink | any(Configuration c).hasFlow(_, sink) |
      element = sink.toString() and
      value = "" and
      sink.hasLocationInfo(file, line, _, _, _)
    )
  }
}
