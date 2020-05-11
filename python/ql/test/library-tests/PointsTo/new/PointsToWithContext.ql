import python
import Util
import semmle.python.pointsto.PointsTo
import semmle.python.pointsto.PointsToContext

from ControlFlowNode f, Object o, ClassObject c, ControlFlowNode x, PointsToContext ctx
where PointsTo::points_to(f, ctx, o, c, x)
select locate(f.getLocation(), "abeghijklmnpqrstu"), f.toString(), repr(o), repr(c),
  x.getLocation().getStartLine(), ctx
