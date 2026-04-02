import python
import Util
private import LegacyPointsTo

from ControlFlowNode f, Object o, ClassObject c, ControlFlowNode x
where PointsTo::points_to(f, _, o, c, x)
select locate(f.getLocation(), "abdeghijkls"), f.toString(), repr(o), repr(c),
  x.getLocation().getStartLine()
