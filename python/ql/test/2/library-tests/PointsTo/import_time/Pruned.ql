import python
import semmle.python.pointsto.PointsTo
import semmle.python.pointsto.PointsToContext

from ControlFlowNode f, Location l, Context c
where
  not PointsToInternal::reachableBlock(f.getBasicBlock(), c) and
  c.isImport() and
  (f.getNode() instanceof FunctionExpr or f.getNode() instanceof ClassExpr) and
  l = f.getLocation() and
  l.getFile().getShortName() = "test.py"
select l.getStartLine()
