import cpp
import semmle.code.cpp.controlflow.Dominance

from Function func, ControlFlowNode dominator, ControlFlowNode node
where
  iDominates(dominator, node) and
  dominator.getControlFlowScope() = func
select func.getName(), dominator.getLocation().getStartLine(), dominator.toString(),
  node.getLocation().getStartLine(), node.toString()
