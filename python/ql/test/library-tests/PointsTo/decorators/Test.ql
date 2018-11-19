import python

from ControlFlowNode f, Object o, ControlFlowNode x, int line

where f.refersTo(o, x) and
f.getLocation().getFile().getBaseName() = "test.py" and
// We don't care about the internals of functools which vary from
// version to version, just the end result.
line = f.getLocation().getStartLine() and line > 40

select line, f.toString(), o.toString(), x.getLocation().toString()
