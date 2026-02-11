private import csharp
private import semmle.code.csharp.dataflow.DataFlow
private import semmle.code.csharp.dataflow.internal.ExternalFlow
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources

private module ThreatModelConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sinkNode(sink, _) }
}

module ThreatModel = TaintTracking::Global<ThreatModelConfig>;
