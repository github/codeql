import csharp
import semmle.code.csharp.dataflow.DataFlow::DataFlow

class FlowConfig extends Configuration {
  FlowConfig() { this = "FlowConfig" }

  override predicate isSource(Node source) { source.asExpr() instanceof Literal }

  override predicate isSink(Node sink) {
    exists(LocalVariable decl | sink.asExpr() = decl.getInitializer())
  }
}

from FlowConfig config, Node source, Node sink
where config.hasFlow(source, sink)
select source, sink
