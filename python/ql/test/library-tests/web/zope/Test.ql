import python
import semmle.python.TestUtils

from ControlFlowNode f, Object o, ControlFlowNode x
where
    exists(ExprStmt s | s.getValue().getAFlowNode() = f) and
    f.refersTo(o, x) and
    f.getLocation().getFile().getBaseName() = "test.py"
select f.getLocation().getStartLine(), f.toString(), o.toString(),
    remove_library_prefix(x.getLocation())
