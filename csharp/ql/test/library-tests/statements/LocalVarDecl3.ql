/**
 * @name Test for local variable declaration statement
 */

import csharp

from Method m, LocalVariableDeclStmt s, LocalVariableDeclExpr b, LocalVariableDeclExpr c
where
  m.getName() = "MainLocalVarDecl" and
  s.getEnclosingCallable() = m and
  s.getVariableDeclExpr(0) = b and
  b.getVariable().getName() = "b" and
  s.getVariableDeclExpr(1) = c and
  c.getVariable().getName() = "c"
select m, s, b, c
