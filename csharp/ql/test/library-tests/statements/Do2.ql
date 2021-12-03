/**
 * @name Test for dos
 */

import csharp

from Method m, DoStmt s
where
  m.getName() = "MainDo" and
  s.getEnclosingCallable() = m
select m, s
