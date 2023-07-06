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

module ZapTest implements TestSig {
  string getARelevantTag() { result = "zap" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "zap" and
    exists(DataFlow::Node sink | any(TestConfig c).hasFlow(_, sink) |
      element = sink.toString() and
      value = "\"" + sink.toString() + "\"" and
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn())
    )
  }
}

import MakeTest<ZapTest>
