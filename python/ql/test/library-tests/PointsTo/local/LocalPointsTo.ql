
import python
import semmle.python.pointsto.PointsTo2
import semmle.python.objects.ObjectInternal

from ControlFlowNode f, ObjectInternal obj, ControlFlowNode orig
where exists(ExprStmt s | s.getValue().getAFlowNode() = f) and
PointsTo2::points_to(f, _, obj, orig)

select f, obj.toString(), orig
