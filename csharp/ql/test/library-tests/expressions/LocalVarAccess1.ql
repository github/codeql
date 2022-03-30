/**
 * @name Test for local variable access
 */

import csharp

from Method m, LocalVariableAccess e
where
  m.hasName("MainLocalVarDecl") and
  e.getEnclosingCallable() = m and
  e.getTarget().getName() = "a" and
  e.getParent() instanceof AssignExpr
select m, e
