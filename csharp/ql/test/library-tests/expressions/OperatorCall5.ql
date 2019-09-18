/**
 * @name Test for user-defined operator "calls"
 */

import csharp

from Method m, MutatorOperatorCall e, IncrementOperator o
where
  m.hasName("MainUnaryOperator") and
  e.getEnclosingCallable() = m and
  e.getTarget() = o and
  e.getArgument(0).(LocalVariableAccess).getTarget().hasName("iv1") and
  e.getNumberOfArguments() = 1 and
  e.isPrefix()
select m, e, o
