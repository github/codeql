import javascript

DataFlow::CallNode getACall(string name) { result.getCalleeName() = name }

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node = getACall("source") }

  predicate isSink(DataFlow::Node node) { node = getACall("sink").getAnArgument() }
}

module TestFlow = TaintTracking::Global<TestConfig>;

deprecated class LegacyConfig extends TaintTracking::Configuration {
  LegacyConfig() { this = "LegacyConfig" }

  override predicate isSource(DataFlow::Node source) { TestConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TestConfig::isSink(sink) }
}

deprecated import utils.test.LegacyDataFlowDiff::DataFlowDiff<TestFlow, LegacyConfig>

from DataFlow::Node src, DataFlow::Node sink
where TestFlow::flow(src, sink)
select src, sink
