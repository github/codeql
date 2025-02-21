import javascript
deprecated import utils.test.ConsistencyChecking

API::Node testInstance() { result = API::moduleImport("@example/test").getInstance() }

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CallNode).getCalleeName() = "source"
    or
    node = testInstance().getMember("getSource").getReturn().asSource()
  }

  predicate isSink(DataFlow::Node node) {
    node = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
    or
    node = testInstance().getMember("getSink").getAParameter().asSink()
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
