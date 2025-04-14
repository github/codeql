private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
import codeql.actions.DataFlow

private class SecretExfiltrationSink extends DataFlow::Node {
  SecretExfiltrationSink() { madSink(this, "secret-exfiltration") }
}

/**
 * A taint-tracking configuration for untrusted data that reaches a sink where it may lead to secret exfiltration
 */
private module SecretExfiltrationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof SecretExfiltrationSink }
}

/** Tracks flow of unsafe user input that is used in a context where it may lead to a secret exfiltration. */
module SecretExfiltrationFlow = TaintTracking::Global<SecretExfiltrationConfig>;
