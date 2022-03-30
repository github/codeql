/**
 * @name Test for property access
 */

import csharp

from Method m, PropertyAccess e
where
  m.hasName("MainAccesses") and
  e.getEnclosingCallable() = m and
  e.getTarget().getName() = "Name" and
  e.getTarget().getDeclaringType() = m.getDeclaringType() and
  e.getQualifier() instanceof ThisAccess
select m, e
