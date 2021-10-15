/**
 * @name ExprsBasic8
 * @kind table
 */

import cpp

from AssignExpr e
where
  e.getEnclosingFunction().hasName("create_foo") and
  e.getRValue() instanceof Literal
select e, e.getRValue()
