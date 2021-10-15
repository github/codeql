// All nodes should be dominated by their associated start node
import default
import semmle.code.java.controlflow.Dominance

ControlFlowNode reachableIn(Method func) {
  result = func.getBody() or
  result = reachableIn(func).getASuccessor()
}

from Method func, ControlFlowNode entry, ControlFlowNode node
where
  func.getBody() = entry and
  reachableIn(func) = node and
  entry != node and
  not strictlyDominates(func.getBody(), node)
select func, node
