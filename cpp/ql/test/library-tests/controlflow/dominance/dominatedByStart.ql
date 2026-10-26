// All nodes should be dominated by their associated start node
import cpp
import semmle.code.cpp.controlflow.Dominance

ControlFlowNode reachableIn(Function func) {
  result = func.getEntryPoint() or
  result = reachableIn(func).getASuccessor()
}

predicate dominatedByStart(Function func, ControlFlowNode node) {
  iDominates(func.getEntryPoint(), node)
  or
  exists(ControlFlowNode dom |
    dominatedByStart(func, dom) and
    iDominates(dom, node)
  )
}

from Function func, ControlFlowNode entry, ControlFlowNode node
where
  func.getEntryPoint() = entry and
  reachableIn(func) = node and
  entry != node and
  not dominatedByStart(func, node)
select func, node
