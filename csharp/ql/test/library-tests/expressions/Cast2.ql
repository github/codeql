/**
 * @name Test for cast expressions
 */

import csharp

from Method m, CastExpr e
where
  m.hasName("MainAccesses") and
  e.getEnclosingCallable() = m and
  e.getExpr().(ULongLiteral).getValue() = "4" and
  e.getTargetType() instanceof IntType
select m, e
