/**
 * @name Test for unchecked statements
 */

import csharp

from Method m, UncheckedStmt s
where
  s.getEnclosingCallable() = m and
  m.getName() = "MainCheckedUnchecked"
select s, s.getBlock()
