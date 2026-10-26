import python

from ControlFlowNode p, ControlFlowNode s
where p.getASuccessor() = s
select p.getLocation().getStartLine().toString(), p.toString(), s.getLocation().getStartLine(),
  s.toString()
