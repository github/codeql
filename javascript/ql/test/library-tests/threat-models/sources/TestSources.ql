import javascript
import utils.test.InlineExpectationsTest

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    exists(CallExpr call |
      call.getAnArgument() = sink.asExpr() and
      call.getCalleeName() = "SINK"
    )
  }
}

module TestFlow = TaintTracking::Global<TestConfig>;

deprecated class LegacyConfig extends TaintTracking::Configuration {
  LegacyConfig() { this = "TestSources" }

  override predicate isSource(DataFlow::Node source) { TestConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TestConfig::isSink(sink) }
}

private module InlineTestSources implements TestSig {
  string getARelevantTag() { result in ["hasFlow", "threat-source"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node sink |
      TestFlow::flowTo(sink) and
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
deprecated import utils.test.LegacyDataFlowDiff::DataFlowDiff<TestFlow, LegacyConfig>
