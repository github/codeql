
import python
private import semmle.python.pointsto.PointsTo
import Util

from ControlFlowNode f, Context ctx
where PointsTo::Test::reachableBlock(f.getBasicBlock(), ctx)
select locate(f.getLocation(), "m"), f.toString(), ctx
