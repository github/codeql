/**
 * @name Test for event access
 */

import csharp

from Method m, EventAccess e, DelegateCall d
where
  m.hasName("OnClick") and
  e.getEnclosingCallable() = m and
  e.getTarget().getName() = "Click" and
  e.getTarget().getDeclaringType() = m.getDeclaringType() and
  d.getEnclosingCallable() = m and
  d.getExpr() = e and
  d.getArgument(0) instanceof ThisAccess and
  d.getArgument(1).(ParameterAccess).getTarget().hasName("e")
select m, d, e
