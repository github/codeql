import csharp
import semmle.code.csharp.security.dataflow.flowsources.FlowSources

module CommandLineFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc | mc.getTarget().hasName("Sink") | sink.asExpr() = mc.getArgument(0))
  }
}

module CommandLineFlow = TaintTracking::Global<CommandLineFlowConfig>;

from DataFlow::Node source, DataFlow::Node sink
where CommandLineFlow::flow(source, sink)
select sink, source
