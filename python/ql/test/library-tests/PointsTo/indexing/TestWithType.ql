import python

from ControlFlowNode f, Object o, ClassObject c, ControlFlowNode x
where
  f.refersTo(o, c, x) and
  f.getLocation().getFile().getBaseName() = "test.py"
select f.getLocation().getStartLine(), f.toString(), o.toString(), c.toString(),
  x.getLocation().getStartLine()
