/**
 * @name Test for unchecked expression
 */

import csharp

from Method m, UncheckedExpr e
where
  m.hasName("MainChecked") and
  e.getEnclosingCallable() = m and
  e.getExpr().(AddExpr).getLeftOperand().(FieldAccess).getTarget().hasName("f") and
  e.getExpr().(AddExpr).getRightOperand().(IntLiteral).getValue() = "20"
select m, e
