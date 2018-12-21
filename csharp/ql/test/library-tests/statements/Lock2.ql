/**
 * @name Test for locks
 */

import csharp

from Method m, LockStmt s
where
  s.getEnclosingCallable() = m and
  m.getName() = "Withdraw"
select s, s.getExpr(), s.getBlock()
