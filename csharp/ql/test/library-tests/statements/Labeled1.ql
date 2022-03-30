/**
 * @name Test for labeled statements
 */

import csharp

from Method m, LabeledStmt s
where
  m.getName() = "MainLabeled" and
  s.getEnclosingCallable() = m
select m, s
