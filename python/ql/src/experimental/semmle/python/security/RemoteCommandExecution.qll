import python
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.DataFlowPublic
import codeql.util.Unit
import experimental.semmle.python.Concepts

module RemoteCommandExecutionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink = any(RemoteCommandExecution rce).getCommand() }
}

/** Global taint-tracking for detecting "secondary server command injection" vulnerabilities. */
module RemoteCommandExecutionFlow = TaintTracking::Global<RemoteCommandExecutionConfig>;
