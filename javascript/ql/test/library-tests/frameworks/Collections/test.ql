import javascript

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getCalleeName() = "source"
  }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::CallNode call | call.getCalleeName() = "sink" | call.getAnArgument() = sink)
  }
}

module TestFlow = DataFlow::Global<TestConfig>;

query predicate dataFlow = TestFlow::flow/2;

deprecated class LegacyConfig extends DataFlow::Configuration {
  LegacyConfig() { this = "Config" }

  override predicate isSource(DataFlow::Node source) { TestConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TestConfig::isSink(sink) }
}

deprecated import utils.test.LegacyDataFlowDiff::DataFlowDiff<TestFlow, LegacyConfig>

DataFlow::SourceNode trackSource(DataFlow::TypeTracker t, DataFlow::SourceNode start) {
  t.start() and
  result.(DataFlow::CallNode).getCalleeName() = "source" and
  start = result
  or
  exists(DataFlow::TypeTracker t2 | t = t2.step(trackSource(t2, start), result))
}

query DataFlow::SourceNode typeTracking(DataFlow::Node start) {
  result = trackSource(DataFlow::TypeTracker::end(), start)
}
