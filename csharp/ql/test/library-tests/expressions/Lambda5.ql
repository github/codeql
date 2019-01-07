/**
 * @name Test for lambda expressions
 */

import csharp

from Assignment assign, LambdaExpr e
where
  assign.getLValue().(VariableAccess).getTarget().hasName("f5") and
  e.getParent+() = assign and
  e.getNumberOfParameters() = 2 and
  e.getParameter(0).getType() instanceof IntType and
  e.getParameter(0).hasName("x") and
  e.getParameter(1).getType() instanceof IntType and
  e.getParameter(1).hasName("y") and
  e.getType().(DelegateType).hasName("S")
select e
