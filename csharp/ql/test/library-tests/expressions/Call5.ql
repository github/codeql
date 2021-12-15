/**
 * @name Test for calls
 */

import csharp

from Method m, MethodCall e, Method t
where
  m.hasName("OtherAccesses") and
  e.getEnclosingCallable() = m and
  e.getNumberOfArguments() = 6 and
  t = e.getTarget() and
  t.hasName("MainAccesses") and
  t.getDeclaringType() = m.getDeclaringType().(NestedType).getDeclaringType() and
  e.getQualifier() instanceof BaseAccess and
  e.getArgument(0) instanceof ThisAccess
select m, e.getAnArgument(), t
