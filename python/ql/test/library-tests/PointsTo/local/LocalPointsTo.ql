import python
import semmle.python.pointsto.PointsTo
import semmle.python.objects.ObjectInternal

from ControlFlowNode f, ObjectInternal obj, ControlFlowNode orig
where
  exists(ExprStmt s | f.getNode() = s.getValue()) and
  PointsTo::pointsTo(f, _, obj, orig)
select f, obj.toString(), orig
