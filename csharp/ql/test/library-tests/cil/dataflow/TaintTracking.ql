import csharp
// Test that all the copies of the taint tracking library can be imported
// simultaneously without errors.
import semmle.code.csharp.dataflow.TaintTracking2
import semmle.code.csharp.dataflow.TaintTracking3
import semmle.code.csharp.dataflow.TaintTracking4
import semmle.code.csharp.dataflow.TaintTracking5

module FlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof Literal }

  predicate isSink(DataFlow::Node sink) {
    exists(LocalVariable decl | sink.asExpr() = decl.getInitializer())
  }
}

module Flow = TaintTracking::Global<FlowConfig>;

from DataFlow::Node source, DataFlow::Node sink
where Flow::flow(source, sink)
select source, sink
