/**
 * @name Test for continues
 */

import csharp

from Method m, ReturnStmt s
where
  m.getName() = "MainReturn" and
  s = m.getBody().getChild(1) and
  s.getEnclosingCallable() = m and
  not exists(s.getExpr())
select m, s
