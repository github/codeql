/**
 * @name Test for try catches
 */

import csharp

from Method m
where
  m.getName() = "MainTryThrow" and
  count(LocalVariable v |
    v.getEnclosingCallable() = m and
    v.getName() = "e"
  ) = 1
select m
