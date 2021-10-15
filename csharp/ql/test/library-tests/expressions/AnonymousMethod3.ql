/**
 * @name Test for anonymous methods
 */

import csharp

from Assignment assign, AnonymousMethodExpr e
where
  assign.getLValue().(VariableAccess).getTarget().hasName("f7") and
  e.getParent+() = assign and
  e.getNumberOfParameters() = 1 and
  e.getType().(DelegateType).getReturnType() instanceof IntType
select e
