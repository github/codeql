/**
 * @name Test for calls
 */

import csharp

from Method m, MethodCall e, Method t
where
  m.hasName("MainAccesses") and
  e.getEnclosingCallable() = m and
  e.getNumberOfArguments() = 2 and
  t = e.getTarget() and
  t.hasName("Bar") and
  e.getArgument(1) instanceof PropertyAccess
select m, e, t
