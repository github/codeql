import python
private import semmle.python.pointsto.PointsTo
import Util

from ControlFlowNode f, Context ctx
where PointsToInternal::reachableBlock(f.getBasicBlock(), ctx)
select locate(f.getLocation(), "m"), f.toString(), ctx
