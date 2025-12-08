import javascript
deprecated import utils.test.ConsistencyChecking
import semmle.javascript.frameworks.data.internal.ApiGraphModels as ApiGraphModels

class TypeModelFromCodeQL extends ModelInput::TypeModel {
  override predicate isTypeUsed(string type) { type = "danger-constant" }

  override DataFlow::Node getASource(string type) {
    type = "danger-constant" and
    result.getStringValue() = "danger-constant"
  }
}

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getCalleeName() = "source"
    or
    source = ModelOutput::getASourceNode("test-source").asSource()
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
    or
    sink = ModelOutput::getASinkNode("test-sink").asSink()
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

query predicate taintFlow(DataFlow::Node source, DataFlow::Node sink) {
  TestFlow::flow(source, sink)
}

query predicate isSink(DataFlow::Node node, string kind) {
  node = ModelOutput::getASinkNode(kind).asSink()
}

query predicate syntaxErrors(ApiGraphModels::AccessPath path) { path.hasSyntaxError() }

query predicate warning = ModelOutput::getAWarning/0;
