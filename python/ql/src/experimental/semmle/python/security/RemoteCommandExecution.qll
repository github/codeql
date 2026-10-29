import python
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.DataFlowPublic
import semmle.python.Concepts
import codeql.util.Unit
import experimental.semmle.python.Concepts

module RemoteCommandExecutionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink = any(RemoteCommandExecution rce).getCommand() }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Global taint-tracking for detecting "secondary server command injection" vulnerabilities. */
module RemoteCommandExecutionFlow = TaintTracking::Global<RemoteCommandExecutionConfig>;
