
import python
import semmle.python.pointsto.PointsTo

from ControlFlowNode f, Location l
where not PointsToInternal::reachableBlock(f.getBasicBlock(), _) and l = f.getLocation() and l.getFile().getName().matches("%test.py")
select l.getStartLine()