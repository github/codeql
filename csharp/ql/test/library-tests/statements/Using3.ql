/**
 * @name Test for usings
 */

import csharp

from Method m, LocalVariable v
where
  m.hasName("MainUsing") and
  v.getVariableDeclExpr().getEnclosingCallable() = m and
  v.getVariableDeclExpr().getParent() instanceof UsingStmt and
  v.hasName("w") and
  v.getType().hasName("TextWriter")
select m, v
