/**
 * @name Test for object creations
 */

import csharp

from Constructor c, ObjectCreation e, Constructor cc
where
  c.hasName("LoginDialog") and
  e.getEnclosingCallable() = c and
  e.getTarget() = cc and
  e.getNumberOfArguments() = 0 and
  cc.hasName("Button")
select c, e, cc
