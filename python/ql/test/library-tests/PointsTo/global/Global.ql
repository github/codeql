import python
import python
import semmle.python.pointsto.PointsTo
import semmle.python.pointsto.PointsToContext
import semmle.python.objects.ObjectInternal

from ControlFlowNode f, PointsToContext ctx, Value obj, ControlFlowNode orig
where
  exists(ExprStmt s | s.getValue().getAFlowNode() = f) and
  PointsTo::pointsTo(f, ctx, obj, orig)
select ctx, f, obj.toString(), orig
