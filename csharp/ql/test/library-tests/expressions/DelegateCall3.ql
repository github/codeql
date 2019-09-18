/**
 * @name Test for delegate calls
 */

import csharp

from Method m, DelegateCall e, LocalVariableAccess a
where
  m.hasName("MainDelegateAndMethodAccesses") and
  e.getEnclosingCallable() = m and
  e.getDelegateExpr() = a and
  a.getTarget().hasName("cd7") and
  a.getTarget().getType().(DelegateType).hasQualifiedName("Expressions.D")
select m, e, a
