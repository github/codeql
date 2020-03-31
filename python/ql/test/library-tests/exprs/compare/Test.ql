import python
import semmle.python.TestUtils

from Compare comp, Expr left, Expr right, Cmpop op
where comp.compares(left, op, right)
select compact_location(comp), comp.toString(), left.toString(), op.toString(), right.toString()
