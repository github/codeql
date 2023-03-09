import java
import semmle.code.java.dataflow.DataFlow
import DataFlow

module Config implements ConfigSig {
  predicate isSource(Node n) { n.asExpr().(MethodAccess).getMethod().hasName("src") }

  predicate isSink(Node n) { n.asExpr().(Argument).getCall().getCallee().hasName("sink") }
}

int explorationLimit() { result = 10 }

module PartialFlow = Make<Config>::FlowExploration<explorationLimit/0>;

import PartialFlow::PartialPathGraph

from PartialFlow::PartialPathNode n, int dist
where PartialFlow::hasPartialFlow(_, n, dist)
select dist, n
