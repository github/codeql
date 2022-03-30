/**
 * @name Test for delegate creations
 */

import csharp

from Method m, ExplicitDelegateCreation e
where
  m.hasName("MainDelegateAndMethodAccesses") and
  e.getEnclosingCallable() = m and
  e.getDelegateType().hasName("D") and
  e.getArgument().(LocalVariableAccess).getTarget().hasName("cd6")
select m, e
