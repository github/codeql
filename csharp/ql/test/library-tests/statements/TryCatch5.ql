/**
 * @name Test for try catches
 */

import csharp

from Method m, TryStmt s, SpecificCatchClause c, LocalVariable v
where
  s.getEnclosingCallable() = m and
  m.getName() = "MainTryThrow" and
  s.getCatchClause(0) = c and
  c.getVariable() = v and
  v.getName() = "e" and
  v.getType().getName() = "Exception"
select c, c.getCaughtExceptionType().toString()
