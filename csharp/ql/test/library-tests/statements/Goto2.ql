/**
 * @name Test for continues
 */

import csharp

from Method m, GotoLabelStmt s
where
  m.getName() = "MainGoto" and
  s.getLabel() = "loop" and
  s.getEnclosingCallable() = m
select m, s
