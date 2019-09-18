/**
 * @name Test for object creations
 */

import csharp

from Method m, ObjectCreation e, Constructor cc
where
  m.hasName("MainUnaryOperator") and
  e.getEnclosingCallable() = m and
  e.getTarget() = cc and
  e.getNumberOfArguments() = 1 and
  e.getArgument(0).getValue() = "4" and
  cc.hasName("IntVector") and
  not e.hasInitializer()
select m, e, cc
