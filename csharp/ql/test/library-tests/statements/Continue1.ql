/**
 * @name Test for continues
 */

import csharp

from Method m, ContinueStmt s
where
  m.getName() = "MainContinue" and
  s.getEnclosingCallable() = m and
  s.getParent().(IfStmt).getThen() = s
select m, s
