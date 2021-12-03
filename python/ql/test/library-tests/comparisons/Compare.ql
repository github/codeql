import python
import semmle.python.Comparisons

from Comparison c, ControlFlowNode l, CompareOp op, float k
where c.tests(l, op, k)
select c.getLocation().getStartLine(), l + " " + op.repr() + " " + k
