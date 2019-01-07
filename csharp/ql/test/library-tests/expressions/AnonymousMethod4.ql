/**
 * @name Test for anonymous methods
 */

import csharp

from Assignment assign, AnonymousMethodExpr e
where
  assign.getLValue().(VariableAccess).getTarget().hasName("f8") and
  e.getParent+() = assign and
  e.hasNoParameters()
select e, e
