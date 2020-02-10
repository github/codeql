/**
 * @kind path-problem
 */

import csharp
import DataFlow::PathGraph

class Conf extends DataFlow::Configuration {
  Conf() { this = "taintgettersetter" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodCall).getTarget().hasName("Taint")
  }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodCall sink | sink.getAnArgument() = n.asExpr() and sink.getTarget().hasName("Sink"))
  }

  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(AddExpr add |
      add.getType() instanceof StringType and add.getAnOperand() = n1.asExpr() and n2.asExpr() = add
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
