/**
 * @name Test for this access
 */

import csharp

from Method m, ThisAccess e
where
  m.hasName("OtherAccesses") and
  e.getEnclosingCallable() = m
select m, e
