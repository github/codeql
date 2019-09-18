/**
 * @name Test for throws
 */

import csharp

from Method m, ThrowStmt s
where
  s.getEnclosingCallable() = m and
  m.getName() = "Divide"
select 1, s.getExpr()
