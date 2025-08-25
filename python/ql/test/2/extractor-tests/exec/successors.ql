import python

from ControlFlowNode p, ControlFlowNode s, string kind, string filename
where
  p.getASuccessor() = s and
  (
    p.getAnExceptionalSuccessor() = s and kind = "exception"
    or
    not p.getAnExceptionalSuccessor() = s and kind = "normal"
  ) and
  filename = p.getLocation().getFile().getShortName() and
  not filename = "__future__.py"
select filename, p.getLocation().getStartLine(), p.toString(), s.getLocation().getStartLine(),
  s.toString(), kind
