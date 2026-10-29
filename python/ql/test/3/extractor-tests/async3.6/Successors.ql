import python

from ControlFlowNode p, ControlFlowNode s
where p.getASuccessor() = s and p.getScope().(Function).isAsync()
select p.getLocation().getStartLine(), p.getNode().toString(), s.getLocation().getStartLine(),
  s.getNode().toString()
