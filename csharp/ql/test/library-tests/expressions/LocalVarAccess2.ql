/**
 * @name Test for local variable access
 */

import csharp

from Method m, LocalVariableAccess e
where
  m.hasName("MainAccesses") and
  e.getEnclosingCallable() = m and
  e.getTarget().getName() = "i" and
  e.getParent() instanceof IndexerAccess
select m, e
