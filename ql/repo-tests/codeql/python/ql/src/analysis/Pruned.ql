import python
import semmle.python.pointsto.PointsTo

from int size
where size = count(ControlFlowNode f | not PointsToInternal::reachableBlock(f.getBasicBlock(), _))
select size
