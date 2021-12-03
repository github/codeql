/**
 * @name Test for user-defined operator "calls"
 */

import csharp

from Method m, OperatorCall e, ExplicitConversionOperator o
where
  m.hasName("MainConversionOperator") and
  e.getEnclosingCallable() = m and
  e.getTarget() = o and
  e.getArgument(0).getValue() = "8"
select m, e, o
