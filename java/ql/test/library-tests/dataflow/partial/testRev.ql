import java
import semmle.code.java.dataflow.DataFlow
import DataFlow

module Config implements ConfigSig {
  predicate isSource(Node n) { n.asExpr().(MethodCall).getMethod().hasName("src") }

  predicate isSink(Node n) { n.asExpr().(Argument).getCall().getCallee().hasName("sink") }
}

int explorationLimit() { result = 10 }

module PartialFlow = Global<Config>::FlowExplorationRev<explorationLimit/0>;

import PartialFlow::PartialPathGraph

from PartialFlow::PartialPathNode n, int dist
where PartialFlow::partialFlow(n, _, dist)
select dist, n
