import python
private import LegacyPointsTo
import Util

from ControlFlowNodeWithPointsTo f, Context ctx, Value v, ControlFlowNode origin
where f.pointsTo(ctx, v, origin)
select locate(f.getLocation(), "abeghijklmnpqrstu"), f.toString(), ctx, vrepr(v),
  vrepr(v.getClass())
