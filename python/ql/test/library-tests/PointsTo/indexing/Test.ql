import python

from ControlFlowNode f, Object o, ControlFlowNode x
where
  f.refersTo(o, x) and
  f.getLocation().getFile().getBaseName() = "test.py"
select f.getLocation().getStartLine(), f.toString(), o.toString(), x.getLocation().getStartLine()
