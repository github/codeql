import python
import semmle.python.Comparisons

from Comparison c, NameNode l, CompareOp op, NameNode r, float k, string add
where
  c.tests(l, op, r, k) and
  (
    k < 0 and add = ""
    or
    k >= 0 and add = "+"
  )
select c.getLocation().getStartLine(), l.getId() + " " + op.repr() + " " + r.getId() + add + k
