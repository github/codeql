/**
 * @name Test for local variable declaration statement
 */

import csharp

from Method m, LocalConstantDeclStmt s, LocalConstantDeclExpr e
where
  m.getName() = "MainLocalConstDecl" and
  s.getEnclosingCallable() = m and
  s.getAVariableDeclExpr() = e and
  e.getVariable().getName() = "r" and
  e.getVariable().getType() instanceof IntType and
  e.getVariable().getValue() = "25"
select m, s, e
