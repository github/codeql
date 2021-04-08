import python
import semmle.python.pointsto.PointsTo

from ControlFlowNode f, Context c, boolean b
where
  exists(Object obj | PointsTo::points_to(f, c, obj, _, _) and obj.booleanValue() = b) and
  not exists(Object obj | PointsTo::points_to(f, c, obj, _, _) and not obj.booleanValue() = b)
select f.getLocation().getFile().getShortName(), f.getLocation().getStartLine(), f.toString(),
  c.toString(), b
