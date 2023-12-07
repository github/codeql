import java
import semmle.code.java.dataflow.DataFlow

StringLiteral src() {
  result.getCompilationUnit().fromSource() and
  result.getFile().toString() = "A"
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr() = src() }

  predicate isSink(DataFlow::Node n) { none() }
}

module Flow = DataFlow::Global<Config>;

int explorationLimit() { result = 100 }

module PartialFlow = Flow::FlowExplorationFwd<explorationLimit/0>;

from PartialFlow::PartialPathNode src, PartialFlow::PartialPathNode sink
where PartialFlow::partialFlow(src, sink, _)
select src, sink
