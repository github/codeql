import csharp
import semmle.code.csharp.dataflow.TaintTracking
// Test that all the copies of the taint tracking library can be imported
// simultaneously without errors.
import semmle.code.csharp.dataflow.TaintTracking2
import semmle.code.csharp.dataflow.TaintTracking3
import semmle.code.csharp.dataflow.TaintTracking4
import semmle.code.csharp.dataflow.TaintTracking5

class FlowConfig extends TaintTracking::Configuration {
  FlowConfig() { this = "FlowConfig" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof Literal }

  override predicate isSink(DataFlow::Node sink) {
    exists(LocalVariable decl | sink.asExpr() = decl.getInitializer())
  }
}

from FlowConfig config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select source, sink
