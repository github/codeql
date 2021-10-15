/**
 * @name Test for anonymous methods
 */

import csharp

from Assignment assign, AnonymousMethodExpr e, Parameter p, ParameterAccess pa
where
  assign.getLValue().(VariableAccess).getTarget().hasName("f7") and
  e.getParent+() = assign and
  e.getNumberOfParameters() = 1 and
  p = e.getParameter(0) and
  pa.getEnclosingStmt().getParent+() = e.getBody() and
  pa.getTarget() = p
select e, p
