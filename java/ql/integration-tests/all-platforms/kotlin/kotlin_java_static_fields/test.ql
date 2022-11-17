import java
import semmle.code.java.dataflow.DataFlow
import DataFlow::PathGraph

class Config extends DataFlow::Configuration {
  Config() { this = "Config" }

  override predicate isSource(DataFlow::Node n) { n.asExpr().(StringLiteral).getValue() = "taint" }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().getName() = "sink"
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Config c
where c.hasFlowPath(source, sink)
select source, source, sink, "flow path"
