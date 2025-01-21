import javascript

query RemoteFlowSource remoteFlow() { any() }

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getCalleeName() = "source"
  }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::CallNode call | call.getCalleeName() = "sink" | call.getAnArgument() = sink)
  }
}

module TestFlow = DataFlow::Global<TestConfig>;

deprecated class LegacyConfig extends DataFlow::Configuration {
  LegacyConfig() { this = "Config" }

  override predicate isSource(DataFlow::Node source) { TestConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TestConfig::isSink(sink) }
}

deprecated import utils.test.LegacyDataFlowDiff::DataFlowDiff<TestFlow, LegacyConfig>

query predicate dataFlow = TestFlow::flow/2;
