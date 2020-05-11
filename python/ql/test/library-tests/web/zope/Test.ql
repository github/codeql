import python
import semmle.python.TestUtils

from ControlFlowNode f, Value v, ControlFlowNode x
where
  exists(ExprStmt s | s.getValue().getAFlowNode() = f) and
  f.pointsTo(v, x) and
  f.getLocation().getFile().getBaseName() = "test.py"
select f.getLocation().getStartLine(), f.toString(), v.toString(),
  remove_library_prefix(x.getLocation())
