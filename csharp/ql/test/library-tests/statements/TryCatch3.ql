/**
 * @name Test for try catches
 */

import csharp

from Method m, TryStmt s
where
  s.getEnclosingCallable() = m and
  m.getName() = "MainTryThrow" and
  count(s.getACatchClause().(GeneralCatchClause)) = 1 and
  count(s.getACatchClause().(SpecificCatchClause)) = 1 and
  s.getCatchClause(0) instanceof SpecificCatchClause and
  s.getCatchClause(1) instanceof GeneralCatchClause
select s, s.getACatchClause()
