/**
 * @name Test for checked statements
 */

import csharp

from Method m, CheckedStmt s
where
  s.getEnclosingCallable() = m and
  m.getName() = "MainCheckedUnchecked"
select s, s.getBlock()
