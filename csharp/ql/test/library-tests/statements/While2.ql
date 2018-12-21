/**
 * @name Test for whiles
 */

import csharp

from Method m, WhileStmt s
where
  m.getName() = "MainWhile" and
  s.getEnclosingCallable() = m
select m, s
