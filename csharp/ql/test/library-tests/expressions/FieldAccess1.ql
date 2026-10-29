/**
 * @name Test for field access
 */

import csharp

from Method m, FieldAccess e
where
  m.hasName("OtherAccesses") and
  e.getEnclosingCallable() = m and
  e.getQualifier() instanceof ThisAccess and
  e.getTarget().getName() = "f"
select m, e
