/**
 * @name ExprsBasic7
 * @kind table
 */

import cpp

from AssignExpr e
where
  e.getEnclosingFunction().hasName("create_foo") and
  e.getLValue() instanceof FieldAccess
select e, e.getLValue()
