/**
 * @name Test for local variable declaration statement
 */

import csharp

from Method m, LocalConstantDeclStmt s, LocalConstantDeclExpr e
where
  m.getName() = "MainLocalConstDecl" and
  s.getEnclosingCallable() = m and
  s.getAVariableDeclExpr() = e and
  e.getVariable().getName() = "pi" and
  e.getVariable().getType() instanceof FloatType and
  e.getInitializer() instanceof FloatLiteral and
  e.getVariable().getValue().matches("3.1415%")
select m, s, e
