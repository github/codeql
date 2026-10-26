/**
 * @name Test for well-formed foreachs
 */

import csharp

from Method m
where
  m.getName() = "MainForeach" and
  count(LocalVariable v |
    v.getVariableDeclExpr().getEnclosingCallable() = m and
    v.getName() = "s"
  ) = 1
select m
