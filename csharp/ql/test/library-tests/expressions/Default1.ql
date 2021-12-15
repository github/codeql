/**
 * @name Test for default value expressions
 */

import csharp

from Method m, DefaultValueExpr e
where
  m.hasName("MainIsAsCast") and
  e.getEnclosingCallable() = m and
  e.getType() instanceof IntType and
  e.getTypeAccess().getTarget() instanceof IntType
select m, e
