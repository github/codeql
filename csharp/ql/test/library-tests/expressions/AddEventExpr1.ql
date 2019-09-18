/**
 * @name Test for add event handlers
 */

import csharp

from Constructor c, AddEventExpr e
where
  c.hasName("LoginDialog") and
  e.getEnclosingCallable() = c and
  e.getTarget().hasName("Click") and
  e.getLValue().getQualifier().(FieldAccess).getTarget().hasName("OkButton")
select c, e
