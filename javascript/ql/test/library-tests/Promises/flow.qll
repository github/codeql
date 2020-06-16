import javascript
private import semmle.javascript.dataflow.internal.StepSummary

class Configuration extends DataFlow::Configuration {
  Configuration() { this = "PromiseDataFlowFlowTestingConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.getEnclosingExpr().getStringValue() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    any(DataFlow::InvokeNode call | call.getCalleeName() = "sink").getAnArgument() = sink
  }
}

class TaintConfig extends TaintTracking::Configuration {
  TaintConfig() { this = "PromiseTaintFlowTestingConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.getEnclosingExpr().getStringValue() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    any(DataFlow::InvokeNode call | call.getCalleeName() = "sink").getAnArgument() = sink
  }
}

query predicate flow(DataFlow::Node source, DataFlow::Node sink) {
  any(Configuration c).hasFlow(source, sink)
}

query predicate exclusiveTaintFlow(DataFlow::Node source, DataFlow::Node sink) {
  not any(Configuration c).hasFlow(source, sink) and
  any(TaintConfig c).hasFlow(source, sink)
}

query predicate typetrack(DataFlow::SourceNode succ, DataFlow::SourceNode pred, StepSummary summary) {
  succ = PromiseTypeTracking::promiseStep(pred, summary)
}
