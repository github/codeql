/**
 * @name Test for try catches
 */

import csharp

from Method m, TryStmt s
where
  s.getEnclosingCallable() = m and
  m.getName() = "MainTryThrow" and
  count(s.getACatchClause()) = 2
select s, s.getACatchClause()
