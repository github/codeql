/**
 * @name Test for property access
 */

import csharp

from Method m, PropertyAccess e
where
  m.hasName("Bar") and
  e.getEnclosingCallable() = m and
  e.getTarget().getName() = "Length" and
  e.getTarget().getDeclaringType() instanceof StringType and
  e.getQualifier().(ParameterAccess).getTarget().getName() = "s" and
  e.getEnclosingStmt() instanceof ReturnStmt
select m, e
