/**
 * @name Test for gotos
 */

import csharp

from Method m, GotoLabelStmt s
where
  m.getName() = "MainGoto" and
  s.getLabel() = "check" and
  s.getEnclosingCallable() = m
select m, s
