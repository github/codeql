/**
 * @name Test for literals
 */

import csharp

from Method m, StringLiteral l
where
  m.hasName("MainLiterals") and
  l.getEnclosingCallable() = m and
  l.getValue().toUpperCase() = "TEST"
select l, l.getValue()
