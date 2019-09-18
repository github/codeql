/**
 * @name Test for delegate creations
 */

import csharp

from Method m, ExplicitDelegateCreation e
where
  m.hasName("MainDelegateAndMethodAccesses") and
  e.getEnclosingCallable() = m and
  e.getDelegateType().hasName("D") and
  e.getArgument().(MethodAccess).getTarget().hasName("M3") and
  e.getArgument().(MethodAccess).getQualifier().(LocalVariableAccess).getTarget().hasName("c")
select m, e
