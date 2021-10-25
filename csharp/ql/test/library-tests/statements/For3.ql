/**
 * @name Test for well-formed fors
 */

import csharp

from Method m, ForStmt s
where
  m.getName() = "MainFor" and
  s.getEnclosingCallable() = m and
  count(s.getAnUpdate()) = 1
select s, s.getUpdate(0)
