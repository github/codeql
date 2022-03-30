/**
 * @name Test for implicit cast
 */

import csharp

from Method m, CastExpr e, VariableAccess access
where
  m.hasName("MainIsAsCast") and
  e.getEnclosingCallable() = m and
  e.getExpr() = access and
  access.getTarget().getName() = "i" and
  e.isImplicit()
select 1
