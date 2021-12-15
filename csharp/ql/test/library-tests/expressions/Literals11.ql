/**
 * @name Test for literals
 */

import csharp

from Method m, NullLiteral l
where
  m.hasName("MainLiterals") and
  l.getEnclosingCallable() = m and
  l.getValue() = "null"
select l
