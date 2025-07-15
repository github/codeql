private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
import codeql.actions.DataFlow
import codeql.actions.security.ControlChecks

private class CommandInjectionSink extends DataFlow::Node {
  CommandInjectionSink() { madSink(this, "command-injection") }
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a system command.
 */
private module CommandInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof CommandInjectionSink }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSourceLocation(DataFlow::Node source) { none() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.getLocation()
    or
    // where clause from CommandInjectionCritical.ql
    exists(Event event | result = event.getLocation() |
      inPrivilegedContext(sink.asExpr(), event) and
      not exists(ControlCheck check |
        check.protects(sink.asExpr(), event, ["command-injection", "code-injection"])
      )
    )
  }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate a system command. */
module CommandInjectionFlow = TaintTracking::Global<CommandInjectionConfig>;
