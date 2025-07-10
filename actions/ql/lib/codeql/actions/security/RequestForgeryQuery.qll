private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
import codeql.actions.DataFlow

private class RequestForgerySink extends DataFlow::Node {
  RequestForgerySink() { madSink(this, "request-forgery") }
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a system command.
 */
private module RequestForgeryConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof RequestForgerySink }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate a system command. */
module RequestForgeryFlow = TaintTracking::Global<RequestForgeryConfig>;
