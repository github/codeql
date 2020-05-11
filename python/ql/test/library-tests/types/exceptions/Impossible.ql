import python

from RaisingNode r, ControlFlowNode n, string kind
where
  r.unlikelySuccessor(n) and
  (
    r.getATrueSuccessor() = n and kind = "true"
    or
    r.getAFalseSuccessor() = n and kind = "false"
    or
    r.getAnExceptionalSuccessor() = n and kind = "exceptional"
    or
    not r.getATrueSuccessor() = n and
    not r.getAFalseSuccessor() = n and
    not r.getAnExceptionalSuccessor() = n and
    kind = "normal"
  )
select r.getLocation().getStartLine(), n.getLocation().getStartLine(), r.getNode().toString(),
  n.getNode().toString(), kind
