// All nodes should be dominated by their associated start node
import default
import semmle.code.java.controlflow.Dominance

ControlFlowNode reachableIn(Method func) {
  result = func.getBody().getControlFlowNode() or
  result = reachableIn(func).getASuccessor()
}

from Method func, ControlFlowNode entry, ControlFlowNode node
where
  func.getBody().getControlFlowNode() = entry and
  reachableIn(func) = node and
  entry != node and
  not strictlyDominates(func.getBody().getControlFlowNode(), node)
select func, node
