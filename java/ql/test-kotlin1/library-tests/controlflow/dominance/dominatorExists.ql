// Every reachable node has a dominator
import default
import semmle.code.java.controlflow.Dominance

/** transitive dominance */
ControlFlowNode reachableIn(Method func) {
  result = func.getBody() or
  result = reachableIn(func).getASuccessor()
}

from Method func, ControlFlowNode node
where
  node = reachableIn(func) and
  node != func.getBody() and
  not iDominates(_, node)
select func, node
