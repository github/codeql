/**
 * @name Test for object creations
 */

import csharp

from Assignment a, CollectionInitializer i
where
  a.getLValue().(VariableAccess).getTarget().hasName("list1") and
  i.getParent+() = a and
  i.getElementInitializer(0).getArgument(0) instanceof AssignExpr
select i.getAChild+()
