import javascript

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(CallExpr).getCalleeName() = "SOURCE"
  }

  predicate isSink(DataFlow::Node sink) {
    exists(CallExpr callExpr |
      callExpr.getCalleeName() = "SINK" and
      DataFlow::valueNode(callExpr.getArgument(0)) = sink
    )
  }
}

module TestFlow = TaintTracking::Global<TestConfig>;

deprecated class LegacyConfig extends TaintTracking::Configuration {
  LegacyConfig() { this = "LegacyConfig" }

  override predicate isSource(DataFlow::Node source) { TestConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TestConfig::isSink(sink) }
}

deprecated import utils.test.LegacyDataFlowDiff::DataFlowDiff<TestFlow, LegacyConfig>

from DataFlow::Node source, DataFlow::Node sink
where TestFlow::flow(source, sink)
select sink
