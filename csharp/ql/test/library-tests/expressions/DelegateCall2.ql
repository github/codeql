/**
 * @name Test for delegate calls
 */

import csharp

from Method m, DelegateCall e, LocalVariableAccess a
where
  m.hasName("MainDelegateAndMethodAccesses") and
  e.getEnclosingCallable() = m and
  e.getNumberOfArguments() = 1 and
  e.getDelegateExpr() = a and
  a.getTarget().hasName("cd7") and
  e.getArgument(0).(AddExpr).getRightOperand().(LocalVariableAccess).getTarget().hasName("x")
select m, e, a
