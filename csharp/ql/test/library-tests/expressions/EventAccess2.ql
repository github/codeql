/**
 * @name Test for event access
 */

import csharp

from Method m, EventAccess e
where
  m.hasName("Reset") and
  e.getEnclosingCallable() = m and
  e.getTarget().getName() = "Click" and
  e.getTarget().getDeclaringType() = m.getDeclaringType() and
  e.getQualifier().isImplicit()
select m, e
