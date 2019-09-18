/**
 * @name Test for object creations
 */

import csharp

from Method m, ObjectCreation e, Constructor cc, CollectionInitializer i
where
  m.hasName("MainCreations") and
  e.getEnclosingCallable() = m and
  e.getTarget() = cc and
  e.getNumberOfArguments() = 0 and
  cc.getDeclaringType().getName() = "List<Contact>" and
  i = e.getInitializer() and
  i.getNumberOfElementInitializers() = 2 and
  i.getElementInitializer(0).getArgument(0) instanceof ObjectCreation and
  i.getElementInitializer(1).getArgument(0) instanceof ObjectCreation
select m, e, i
