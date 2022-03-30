/**
 * @name Test for well-formed fors
 */

import csharp

from Method m, ForStmt s
where
  m.getName() = "MainFor" and
  s.getEnclosingCallable() = m
select s, s.getCondition()
