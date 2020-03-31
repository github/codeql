import python

from ControlFlowNode f, Context ctx, Value v, ControlFlowNode origin
where f.pointsTo(ctx, v, origin)
select f, ctx, v
