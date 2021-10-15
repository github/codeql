/**
 * @name Test for delegate creations
 */

import csharp

from Method m, ImplicitDelegateCreation e
where
  m.hasName("MainDelegateAndMethodAccesses") and
  e.getEnclosingCallable() = m and
  e.getDelegateType().hasName("D") and
  e.getArgument().(MethodAccess).getTarget().hasName("M2")
select m, e
