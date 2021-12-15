/**
 * @name CompareTest
 * @description CompareTest
 * @kind table
 * @problem.severity warning
 */

import python

from CompareNode c, NameNode l, NameNode r, Cmpop op, int line, Variable vl, Variable vr
where
  c.operands(l, op, r) and
  line = c.getLocation().getStartLine() and
  line = l.getLocation().getStartLine() and
  line = r.getLocation().getStartLine() and
  l.uses(vl) and
  r.uses(vr)
select line, c.toString(), vl.getId(), vr.getId(), op.getSymbol()
