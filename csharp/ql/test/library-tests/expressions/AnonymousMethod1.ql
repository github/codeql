/**
 * @name Test for anonymous methods
 */

import csharp

from Assignment assign, AnonymousMethodExpr e
where
  assign.getLValue().(VariableAccess).getTarget().hasName("f7") and
  e.getParent+() = assign and
  e.getNumberOfParameters() = 1 and
  e.getParameter(0).getType() instanceof IntType and
  e.getParameter(0).hasName("x")
select e
