import python

from ControlFlowNode p, ControlFlowNode s
where p.getASuccessor() = s
select p.getLocation().getStartLine(), p.toString(), s.getLocation().getStartLine(), s.toString()
