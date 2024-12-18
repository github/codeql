import java
import semmle.code.java.dataflow.DataFlow
import Flow::PathGraph

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().(StringLiteral).getValue() = "taint" }

  predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().getName() = "sink"
  }
}

module Flow = DataFlow::Global<Config>;

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select source, source, sink, "flow path"
