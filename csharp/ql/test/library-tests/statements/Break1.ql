/**
 * @name Test for breaks
 */

import csharp

from Method m, BreakStmt s
where
  m.getName() = "MainBreak" and
  s.getEnclosingCallable() = m and
  s.getParent().(IfStmt).getThen() = s
select m, s
