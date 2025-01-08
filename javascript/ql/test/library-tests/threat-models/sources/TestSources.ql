import javascript
import utils.test.InlineExpectationsTest

class TestSourcesConfiguration extends TaintTracking::Configuration {
  TestSourcesConfiguration() { this = "TestSources" }

  override predicate isSource(DataFlow::Node source) { source instanceof ThreatModelSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(CallExpr call |
      call.getAnArgument() = sink.asExpr() and
      call.getCalleeName() = "SINK"
    )
  }
}

private module InlineTestSources implements TestSig {
  string getARelevantTag() { result in ["hasFlow", "threat-source"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node sink |
      any(TestSourcesConfiguration c).hasFlow(_, sink) and
      value = "" and
      location = sink.getLocation() and
      tag = "hasFlow" and
      element = sink.toString()
    )
    or
    exists(ThreatModelSource source |
      value = source.getThreatModel() and
      location = source.getLocation() and
      tag = "threat-source" and
      element = source.toString()
    )
  }
}

import MakeTest<InlineTestSources>
