/**
 * @name Test for local variable declaration statement
 */

import csharp

from Method m, LocalVariableDeclStmt s, LocalVariableDeclExpr e
where
  m.getName() = "MainLocalVarDecl" and
  s.getEnclosingCallable() = m and
  s.getAVariableDeclExpr() = e and
  e.getVariable().getName() = "a" and
  e.getVariable().getType() instanceof IntType
select m, s, e
