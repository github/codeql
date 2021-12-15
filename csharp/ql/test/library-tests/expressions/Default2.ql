/**
 * @name Test for default value expressions
 */

import csharp

from Method m, DefaultValueExpr e, TypeParameter t
where
  m.hasName("PrintTypes") and
  e.getEnclosingCallable() = m and
  e.getType() = e.getTypeAccess().getTarget() and
  e.getType() = t and
  t.hasName("T")
select m, e, t
