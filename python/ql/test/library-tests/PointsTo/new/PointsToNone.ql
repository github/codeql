import python
private import LegacyPointsTo
import Util

from ControlFlowNodeWithPointsTo f, ControlFlowNode x
where f.refersTo(theNoneObject(), _, x)
select locate(f.getLocation(), "abcdghijklmopqr"), f.toString(), x.getLocation().getStartLine()
