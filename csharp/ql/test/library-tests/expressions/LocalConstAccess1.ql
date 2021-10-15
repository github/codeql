/**
 * @name Test for local constant access
 */

import csharp

from Method m, LocalVariableAccess e, LocalConstant c
where
  m.hasName("MainLocalConstDecl") and
  e.getEnclosingCallable() = m and
  e.getTarget() = c and
  c.getName() = "pi" and
  e.getParent().getParent().getParent() instanceof Call
select m, e
