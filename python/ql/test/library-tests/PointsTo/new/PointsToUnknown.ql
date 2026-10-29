import python
import Util
private import LegacyPointsTo

from ControlFlowNode f, ControlFlowNode x
where PointsTo::pointsTo(f, _, ObjectInternal::unknown(), x)
select locate(f.getLocation(), "abchr"), f.toString(), x.getLocation().getStartLine()
