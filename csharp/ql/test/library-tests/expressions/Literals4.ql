/**
 * @name Test for literals
 */

import csharp

from Method m, LongLiteral l
where
  m.hasName("MainLiterals") and
  l.getEnclosingCallable() = m and
  l.getValue() = "8989898"
select l
