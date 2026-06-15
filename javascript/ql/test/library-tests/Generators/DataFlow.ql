import javascript
deprecated import utils.test.ConsistencyChecking

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr().getStringValue() = "source" }

  predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
  }
}

module TestFlow = DataFlow::Global<TestConfig>;

deprecated class LegacyConfig extends DataFlow::Configuration {
  LegacyConfig() { this = "GeneratorFlowConfig" }

  override predicate isSource(DataFlow::Node source) { TestConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TestConfig::isSink(sink) }
}

deprecated import utils.test.LegacyDataFlowDiff::DataFlowDiff<TestFlow, LegacyConfig>

deprecated class Consistency extends ConsistencyConfiguration {
  Consistency() { this = "Consistency" }

  override DataFlow::Node getAnAlert() { TestFlow::flowTo(result) }
}
