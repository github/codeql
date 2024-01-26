/**
 * @name Test for inline array access
 */

import csharp

from Method m, ArrayAccess e
where
  m.hasName("MainAccesses") and
  e.getEnclosingCallable() = m and
  e.getQualifier().(LocalVariableAccess).getTarget().getName() = "inlinearray" and
  e.getIndex(0).(IntLiteral).getValue() = "2"
select m, e
