import python

// We don't care about the internals of functools which vary from
// version to version, just the end result.
from NameNode f, Object o, ControlFlowNode x, int line
where
  f.refersTo(o, x) and
  f.getLocation().getFile().getBaseName() = "test.py" and
  line = f.getLocation().getStartLine()
select line, f.toString(), o.toString(), x.getLocation().toString()
