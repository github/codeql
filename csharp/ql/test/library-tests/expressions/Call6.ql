/**
 * @name Test for calls
 */

import csharp

from Method m, MethodCall e, Method t, CastExpr cast
where
  m.hasName("OtherAccesses") and
  e.getEnclosingCallable() = m and
  t = e.getTarget() and
  t.hasName("MainAccesses") and
  e.getArgument(1) = cast and
  cast.getExpr() instanceof IntLiteral and
  cast.getExpr().getValue() = "1"
select m, e.getAnArgument(), t
