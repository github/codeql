import cpp
import semmle.code.cpp.controlflow.Dominance

from Function func, BasicBlock dominator, BasicBlock node
where
  bbIDominates(dominator, node) and
  dominator.getNode(0).getControlFlowScope() = func
select func.getName(), dominator.getNode(0).getLocation().getStartLine(),
  dominator.getNode(0).toString(), node.getNode(0).getLocation().getStartLine(),
  node.getNode(0).toString()
