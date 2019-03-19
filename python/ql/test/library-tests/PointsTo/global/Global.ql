
import python


import python
import semmle.python.pointsto.PointsTo2
import semmle.python.pointsto.PointsToContext2
import semmle.python.objects.ObjectInternal

from ControlFlowNode f, PointsToContext2 ctx, ObjectInternal obj, ControlFlowNode orig
where exists(ExprStmt s | s.getValue().getAFlowNode() = f) and
PointsTo2::points_to(f, ctx, obj, orig)

select ctx, f, obj.toString(), orig
