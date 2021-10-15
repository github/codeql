import python
import semmle.python.pointsto.PointsTo
import semmle.python.objects.ObjectInternal

from ControlFlowNode f, ObjectInternal v, ControlFlowNode x
where PointsTo::pointsTo(f, _, v, x)
select f.getLocation().getStartLine(), f.toString(), v, x.getLocation().getStartLine()
