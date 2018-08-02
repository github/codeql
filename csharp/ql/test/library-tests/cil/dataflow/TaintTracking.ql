import csharp
import semmle.code.csharp.dataflow.TaintTracking

class FlowConfig extends TaintTracking::Configuration {
  FlowConfig() { this="FlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof Literal
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(LocalVariable decl | sink.asExpr()=decl.getInitializer())
  }
}

from FlowConfig config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select source, sink
