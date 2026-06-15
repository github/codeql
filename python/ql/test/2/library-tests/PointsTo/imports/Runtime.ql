import python
private import LegacyPointsTo

from int line, ControlFlowNodeWithPointsTo f, Object o, ControlFlowNode orig
where
  not f.getLocation().getFile().inStdlib() and
  f.refersTo(o, orig) and
  line = f.getLocation().getStartLine() and
  line != 0 and
  not o instanceof NumericObject // Omit sys.hexversion as it will change between machines
select f.getLocation().getFile().getShortName(), line, f.toString(), o.toString(), orig.toString()
