/**
 * @name Test for base access
 */

import csharp

from Method m, BaseAccess e
where
  m.hasName("OtherAccesses") and
  e.getEnclosingCallable() = m
select m, e
