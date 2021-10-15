/**
 * @name Test for try finallys
 */

import csharp

from Method m, TryStmt s
where
  s.getEnclosingCallable() = m and
  m.getName() = "MainTryThrow"
select s.getFinally()
