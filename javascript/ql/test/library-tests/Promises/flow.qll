import javascript
private import semmle.javascript.dataflow.internal.StepSummary
deprecated import utils.test.LegacyDataFlowDiff

module ValueFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.getEnclosingExpr().getStringValue() = "source"
  }

  predicate isSink(DataFlow::Node sink) {
    any(DataFlow::InvokeNode call | call.getCalleeName() = "sink").getAnArgument() = sink
  }
}

module ValueFlow = DataFlow::Global<ValueFlowConfig>;

module TaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.getEnclosingExpr().getStringValue() = "source"
  }

  predicate isSink(DataFlow::Node sink) {
    any(DataFlow::InvokeNode call | call.getCalleeName() = "sink").getAnArgument() = sink
  }
}

module TaintFlow = TaintTracking::Global<TaintConfig>;

query predicate flow(DataFlow::Node source, DataFlow::Node sink) { ValueFlow::flow(source, sink) }

query predicate exclusiveTaintFlow(DataFlow::Node source, DataFlow::Node sink) {
  not ValueFlow::flow(source, sink) and
  TaintFlow::flow(source, sink)
}

query predicate typetrack(DataFlow::SourceNode succ, DataFlow::SourceNode pred, StepSummary summary) {
  succ = PromiseTypeTracking::promiseStep(pred, summary)
}

deprecated class LegacyValueConfig extends DataFlow::Configuration {
  LegacyValueConfig() { this = "LegacyValueConfig" }

  override predicate isSource(DataFlow::Node source) { ValueFlowConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { ValueFlowConfig::isSink(sink) }
}

deprecated query predicate valueFlowDifference =
  DataFlowDiff<ValueFlow, LegacyValueConfig>::legacyDataFlowDifference/3;

deprecated class LegacyTaintConfig extends TaintTracking::Configuration {
  LegacyTaintConfig() { this = "LegacyTaintConfig" }

  override predicate isSource(DataFlow::Node source) { TaintConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TaintConfig::isSink(sink) }
}

deprecated query predicate taintFlowDifference =
  DataFlowDiff<TaintFlow, LegacyTaintConfig>::legacyDataFlowDifference/3;
