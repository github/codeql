// Every reachable node has a dominator
import cpp
import semmle.code.cpp.controlflow.Dominance

ControlFlowNode reachableIn(Function func) {
  result = func.getEntryPoint() or
  result = reachableIn(func).getASuccessor()
}

from Function func, ControlFlowNode node
where
  node = reachableIn(func) and
  node != func.getEntryPoint() and
  not iDominates(_, node)
select func, node
