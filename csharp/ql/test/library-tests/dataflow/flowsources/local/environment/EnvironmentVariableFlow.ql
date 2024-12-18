import csharp
import semmle.code.csharp.dataflow.internal.ExternalFlow

module EnvironmentVariableFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { sourceNode(source, "environment") }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc | mc.getTarget().hasName("Sink") | sink.asExpr() = mc.getArgument(0))
  }
}

module EnvironmentVariableFlow = TaintTracking::Global<EnvironmentVariableFlowConfig>;

from DataFlow::Node source, DataFlow::Node sink
where EnvironmentVariableFlow::flow(source, sink)
select sink, source
