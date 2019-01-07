/**
 * @name Test for anonymous methods
 */

import csharp

from Assignment assign, AnonymousMethodExpr e, LocalVariableAccess va
where
  assign.getLValue().(VariableAccess).getTarget().hasName("f8") and
  e.getParent+() = assign and
  e.hasNoParameters() and
  va.getEnclosingStmt().getParent+() = e.getBody() and
  va.getTarget().hasName("j")
select e, va
