/**
 * @name Test for literals
 */

import csharp

from Method m, IntLiteral l
where
  m.hasName("MainLiterals") and
  l.getEnclosingCallable() = m and
  l.getValue() = "1"
select l
