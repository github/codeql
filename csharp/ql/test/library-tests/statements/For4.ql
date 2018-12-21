/**
 * @name Test for well-formed fors
 */

import csharp

from Method m, ForStmt s
where
  m.getName() = "MainFor" and
  s.getEnclosingCallable() = m and
  count(s.getAnInitializer()) = 1
select s, s.getInitializer(0)
