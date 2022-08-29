/**
 * @kind path-problem
 */

import csharp
import DataFlow::PathGraph

class Conf extends DataFlow::Configuration {
  Conf() { this = "ArrayFlowConf" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ObjectCreation }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasUndecoratedName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }

  override int fieldFlowBranchLimit() { result = 100 }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
