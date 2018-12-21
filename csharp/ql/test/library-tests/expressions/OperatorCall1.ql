/**
 * @name Test for user-defined operator "calls"
 */

import csharp

from Method m, OperatorCall e, AddOperator o
where
  m.hasName("MainUnaryOperator") and
  e.getEnclosingCallable() = m and
  e.getTarget() = o and
  e.getArgument(0).(LocalVariableAccess).getTarget().hasName("iv1") and
  e.getArgument(1).(LocalVariableAccess).getTarget().hasName("iv2") and
  e.getNumberOfArguments() = 2
select m, e, o
