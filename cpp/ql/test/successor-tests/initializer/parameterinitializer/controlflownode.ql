import cpp

from ControlFlowNode n
select n.getLocation().getStartLine(), n.getControlFlowScope(), n, count(n.getAPredecessor()),
  count(n.getASuccessor())
