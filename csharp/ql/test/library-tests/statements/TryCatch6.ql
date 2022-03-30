/**
 * @name Test for try catches
 */

import csharp

from Method m, TryStmt s, LocalVariable v, LocalVariableAccess a
where
  s.getEnclosingCallable() = m and
  m.getName() = "MainTryThrow" and
  s.getCatchClause(0).(SpecificCatchClause).getVariable() = v and
  v.getName() = "e" and
  v.getType().getName() = "Exception" and
  a.getTarget() = v and
  a.getEnclosingStmt().getParent() = s.getCatchClause(0).getBlock()
select v, a
