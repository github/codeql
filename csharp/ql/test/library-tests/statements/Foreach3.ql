/**
 * @name Test for well-formed foreachs
 */

import csharp

from Method m, ForeachStmt s
where
  m.getName() = "MainForeach" and
  s.getEnclosingCallable() = m and
  s.getVariable().getName() = "s" and
  s.getVariable().getType() instanceof StringType
select s, s.getVariable()
