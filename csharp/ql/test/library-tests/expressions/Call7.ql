/**
 * @name Test for calls
 */

import csharp

from Method m, MethodCall e, Method t
where
  m.hasName("MainLocalVarDecl") and
  e.getEnclosingCallable() = m and
  t = e.getTarget() and
  t.hasName("WriteLine") and
  t.getDeclaringType().hasQualifiedName("System", "Console") and
  e.getArgument(0) instanceof AddExpr
select m, e.getAnArgument(), t.toString()
