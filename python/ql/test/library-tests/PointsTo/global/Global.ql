import python
private import LegacyPointsTo

from ControlFlowNode f, PointsToContext ctx, Value obj, ControlFlowNode orig
where
  exists(ExprStmt s | f.getNode() = s.getValue()) and
  PointsTo::pointsTo(f, ctx, obj, orig)
select ctx, f, obj.toString(), orig
