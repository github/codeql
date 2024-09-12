import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { sources(source) }

  predicate isSink(DataFlow::Node sink) { sinks(sink) }
}

module Flow = DataFlow::Global<Config>;

query predicate paths(DataFlow::Node source, DataFlow::Node sink) { Flow::flow(source, sink) }

query predicate sources(DataFlow::Node source) { source instanceof RemoteFlowSource }

query predicate sinks(DataFlow::Node sink) { sink = any(FileSystemAccess fsa).getAPathArgument() }
