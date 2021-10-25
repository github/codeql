import java
import semmle.code.java.dataflow.DataFlow
import DataFlow
import PartialPathGraph

class Conf extends Configuration {
  Conf() { this = "partial flow" }

  override predicate isSource(Node n) { n.asExpr().(MethodAccess).getMethod().hasName("src") }

  override predicate isSink(Node n) { n.asExpr().(Argument).getCall().getCallee().hasName("sink") }

  override int explorationLimit() { result = 10 }
}

from PartialPathNode n, int dist
where any(Conf c).hasPartialFlowRev(n, _, dist)
select dist, n
