/**
 * @kind path-problem
 */

import csharp
import DataFlow
import DataFlow::PathGraph

class FlowConfig extends Configuration {
  FlowConfig() { this = "FlowConfig" }

  override predicate isSource(Node source) { source.asExpr() instanceof Literal }

  override predicate isSink(Node sink) {
    exists(LocalVariable decl | sink.asExpr() = decl.getInitializer())
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, FlowConfig config
where config.hasFlowPath(source, sink)
select source, sink, sink, "$@", sink, sink.toString()
