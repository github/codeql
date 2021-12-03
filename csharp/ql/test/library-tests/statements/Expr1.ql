/**
 * @name Test for expression statements
 */

import csharp

from Method m
where
  m.getName() = "MainExpr" and
  count(ExprStmt s | s.getEnclosingCallable() = m) = 4
select m
