import go
import TestUtilities.InlineExpectationsTest

class TestConfig extends TaintTracking::Configuration {
  TestConfig() { this = "test config" }

  override predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getTarget().getName() = ["getUntrustedData", "getUntrustedString"]
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(LoggerCall log).getAMessageComponent()
  }
}

class ZapTest extends InlineExpectationsTest {
  ZapTest() { this = "ZapTest" }

  override string getARelevantTag() { result = "zap" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "zap" and
    exists(DataFlow::Node sink | any(TestConfig c).hasFlow(_, sink) |
      element = sink.toString() and
      value = "\"" + sink.toString() + "\"" and
      sink.hasLocationInfo(file, line, _, _, _)
    )
  }
}
