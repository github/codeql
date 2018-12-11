import python
import Util
import semmle.python.pointsto.PointsTo

from ControlFlowNode f, ControlFlowNode x

where PointsTo::points_to(f, _, unknownValue(), _, x)

select locate(f.getLocation(), "abchr"), f.toString(), x.getLocation().getStartLine()
