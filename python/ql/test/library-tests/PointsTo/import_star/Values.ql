import python
private import LegacyPointsTo

from ControlFlowNodeWithPointsTo f, Context ctx, Value v, ControlFlowNode origin
where f.pointsTo(ctx, v, origin)
select f, ctx, v
