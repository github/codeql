/**
 * @name Test for delegate calls
 */

import csharp

from Method m, DelegateCall e, LocalVariableAccess a
where
  m.hasName("MainDelegateAndMethodAccesses") and
  e.getEnclosingCallable() = m and
  e.getNumberOfArguments() = 1 and
  e.getExpr() = a and
  a.getTarget().hasName("cd1") and
  e.getArgument(0).getValue() = "-40"
select m, e, a
