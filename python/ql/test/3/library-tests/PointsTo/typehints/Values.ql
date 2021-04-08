import python

from ControlFlowNode f, Context ctx, Value v, ControlFlowNode origin
where
  f.pointsTo(ctx, v, origin) and
  f.getLocation().getFile().getBaseName() = "test.py"
select f.getLocation(), f.toString(), ctx, v
