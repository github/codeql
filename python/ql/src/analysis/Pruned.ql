
import python
import semmle.python.pointsto.PointsTo

from int size

where
size = count(ControlFlowNode f |
    not PointsTo::Test::reachableBlock(f.getBasicBlock(), _)
)


select size
