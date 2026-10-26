/**
 * @name Test for literals
 */

import csharp

from Method m, BoolLiteral t, BoolLiteral f
where
  m.hasName("MainLiterals") and
  t.getEnclosingCallable() = m and
  t.getValue() = "true" and
  f.getEnclosingCallable() = m and
  f.getValue() = "false"
select t, f
