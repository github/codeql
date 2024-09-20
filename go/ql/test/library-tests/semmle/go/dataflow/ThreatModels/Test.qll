private import go
private import semmle.go.security.FlowSources
private import semmle.go.dataflow.ExternalFlow
private import semmle.go.dataflow.DataFlow

private module ThreatModelConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode c | c.getTarget().getName() = "sink").getAnArgument()
  }
}

module ThreatModelFlow = TaintTracking::Global<ThreatModelConfig>;
