import python
import Util
import semmle.python.pointsto.PointsTo

from ControlFlowNode f, ControlFlowNode x
where PointsTo::pointsTo(f, _, ObjectInternal::unknown(), x)
select locate(f.getLocation(), "abchr"), f.toString(), x.getLocation().getStartLine()
