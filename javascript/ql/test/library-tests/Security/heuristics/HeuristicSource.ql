import javascript
private import semmle.javascript.heuristics.AdditionalSources
deprecated import utils.test.ConsistencyChecking

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof HeuristicSource }

  predicate isSink(DataFlow::Node node) {
    node = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
  }
}

module TestFlow = TaintTracking::Global<TestConfig>;

deprecated class Consistency extends ConsistencyConfiguration {
  Consistency() { this = "Consistency" }

  override DataFlow::Node getAnAlert() { TestFlow::flowTo(result) }
}

deprecated class LegacyConfig extends TaintTracking::Configuration {
  LegacyConfig() { this = "LegacyConfig" }

  override predicate isSource(DataFlow::Node source) { TestConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TestConfig::isSink(sink) }
}

deprecated import utils.test.LegacyDataFlowDiff::DataFlowDiff<TestFlow, LegacyConfig>
