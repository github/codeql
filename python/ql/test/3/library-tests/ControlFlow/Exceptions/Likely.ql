import python

from ControlFlowNode r, ControlFlowNode s
where
  s = r.getAnExceptionalSuccessor() and
  not r.(RaisingNode).unlikelySuccessor(s)
select r.getLocation().getStartLine(), r.toString(), s.getLocation().getStartLine(), s.toString()
