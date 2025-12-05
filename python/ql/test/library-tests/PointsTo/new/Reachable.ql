import python
private import LegacyPointsTo
import Util

from ControlFlowNode f, Context ctx
where PointsToInternal::reachableBlock(f.getBasicBlock(), ctx)
select locate(f.getLocation(), "m"), f.toString(), ctx
