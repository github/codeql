import python

string short_loc(Location l) { result = l.getFile().getShortName() + ":" + l.getStartLine() }

from ControlFlowNode use, Object obj, ControlFlowNode orig, int line
where
  use.refersTo(obj, orig) and
  use.getLocation().getFile().getShortName() = "test.py" and
  line = use.getLocation().getStartLine() and
  not line = 0
select line, use.toString(), obj.toString(), short_loc(orig.getLocation())
