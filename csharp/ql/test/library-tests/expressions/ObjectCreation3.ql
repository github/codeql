/**
 * @name Test for object creations
 */

import csharp

from Method m, ObjectCreation e, Constructor cc, ObjectOrCollectionInitializer i
where
  m.hasName("MainCreations") and
  e.getEnclosingCallable() = m and
  e.getTarget() = cc and
  e.getNumberOfArguments() = 0 and
  cc.hasName("Point") and
  i = e.getInitializer()
select m, e, cc, i
