/**
 * @name Test for array access
 */

import csharp

from Method m, ArrayAccess e
where
  m.hasName("MainAccesses") and
  e.getEnclosingCallable() = m and
  e.getQualifier().(LocalVariableAccess).getTarget().getName() = "array" and
  e.getIndex(0).(IntLiteral).getValue() = "1"
select m, e
