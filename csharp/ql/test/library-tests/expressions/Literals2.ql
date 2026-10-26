/**
 * @name Test for literals
 */

import csharp

from Method m, CharLiteral l
where
  m.hasName("MainLiterals") and
  l.getEnclosingCallable() = m and
  l.getValue() = "@"
select l
