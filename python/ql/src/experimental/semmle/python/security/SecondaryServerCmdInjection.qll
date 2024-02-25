import python
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.DataFlowPublic
import codeql.util.Unit
import SecondaryServerCmdInjectionCustomizations

module SecondaryCommandInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof SecondaryCommandInjection::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof SecondaryCommandInjection::Sink }
}

/** Global taint-tracking for detecting "paramiko command injection" vulnerabilities. */
module SecondaryCommandInjectionFlow = TaintTracking::Global<SecondaryCommandInjectionConfig>;
