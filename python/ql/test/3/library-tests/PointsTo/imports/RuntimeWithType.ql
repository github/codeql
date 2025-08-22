import python

from int line, ControlFlowNode f, Object o, ClassObject cls, ControlFlowNode orig
where
  not f.getLocation().getFile().inStdlib() and
  f.refersTo(o, cls, orig) and
  line = f.getLocation().getStartLine() and
  line != 0
select f.getLocation().getFile().getShortName(), line, f.toString(), o.toString(), cls.toString(),
  orig.toString()
