/**
 * @name Test for lambda expressions
 */

import csharp

from Assignment assign, LambdaExpr e
where
  assign.getLValue().(VariableAccess).getTarget().hasName("f6") and
  e.getParent+() = assign and
  e.getNumberOfParameters() = 0 and
  e.getType().(DelegateType).hasName("Unit") and
  e.getExpressionBody() instanceof Call
select e
