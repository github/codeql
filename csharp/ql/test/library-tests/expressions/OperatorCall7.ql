/**
 * @name Test for user-defined operator "calls"
 */

import csharp

from Method m, OperatorCall e, AddOperator t
where
  m.hasName("delegateCombine") and
  e.getEnclosingCallable() = m and
  t = e.getTarget()
select m, m.getDeclaringType(), e.getAnArgument(), t.getDeclaringType()
