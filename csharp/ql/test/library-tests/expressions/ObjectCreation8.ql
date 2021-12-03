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
  cc.getName().matches("List%") and
  i = e.getInitializer() and
  i.getNumberOfElementInitializers() = 10 and
  forall(int d | d in [0 .. 9] |
    i.getElementInitializer(d).getArgument(0).getValue() = d.toString()
  )
select m, e, i
