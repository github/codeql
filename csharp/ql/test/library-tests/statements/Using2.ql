/**
 * @name Test for usings
 */

import csharp

from Method m
where
  m.hasName("MainUsing") and
  count(LocalVariable v |
    v.getVariableDeclExpr().getEnclosingCallable() = m and
    v.hasName("w")
  ) = 1
select m
