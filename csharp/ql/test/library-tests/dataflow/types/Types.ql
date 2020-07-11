/**
 * @kind path-problem
 */

import csharp
import DataFlow::PathGraph

class Conf extends DataFlow::Configuration {
  Conf() { this = "TypesConf" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() instanceof ObjectCreation or
    src.asExpr() instanceof NullLiteral
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
