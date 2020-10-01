import python
import semmle.python.Comparisons

from ComparisonControlBlock comp, SsaVariable v, CompareOp op, float k, BasicBlock b
where comp.controls(v.getAUse(), op, k, b)
select comp.getTest().getLocation().getStartLine(), v.getId() + " " + op.repr() + " " + k,
  b.getNode(0).getLocation().getStartLine()
