/**
 * @name Test for parameter access
 */

import csharp

from Method m, ParameterAccess e
where
  m.hasName("Bar") and
  e.getEnclosingCallable() = m and
  e.getTarget().getName() = "x" and
  e.getEnclosingStmt() instanceof ReturnStmt
select m, e
