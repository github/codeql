/**
 * @kind path-problem
 */

import csharp
import DataFlow::PathGraph

class DataflowConfiguration extends DataFlow::Configuration {
  DataflowConfiguration() { this = "data flow configuration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(Expr).getValue() = "tainted"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(LocalVariable v | sink.asExpr() = v.getInitializer())
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, DataflowConfiguration conf
where conf.hasFlowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
