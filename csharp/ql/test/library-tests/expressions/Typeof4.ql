/**
 * @name Test for typeof expressions
 */

import csharp

from Method m, TypeofExpr e
where
  m.hasName("PrintTypes") and
  e.getEnclosingCallable() = m and
  e.getTypeAccess().getTarget().hasName("X<X`1>")
select m, e.getType().toString()
