/**
 * @name Test for object creations
 */

import csharp

from Assignment a, CollectionInitializer i, AnonymousObjectCreation o
where
  a.getLValue().(VariableAccess).getTarget().hasName("list2") and
  i.getParent+() = a and
  i.getElementInitializer(0).getArgument(0) = o
select i, o
