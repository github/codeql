/**
 * @name Test for parameter access
 */

import csharp

from Property p, ParameterAccess e
where
  p.hasName("Name") and
  e.getEnclosingCallable() = p.getSetter() and
  e.getTarget().getName() = "value" and
  e.getEnclosingStmt().(ExprStmt).getExpr() instanceof AssignExpr and
  e.getTarget().getDeclaringElement() = p.getSetter()
select p, e
