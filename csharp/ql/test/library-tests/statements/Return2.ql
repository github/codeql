/**
 * @name Test for continues
 */

import csharp

from Method m, ReturnStmt s
where
  m.getName() = "Add" and
  s = m.getBody().getChild(0) and
  s.getEnclosingCallable() = m
select m, s, s.getExpr()
