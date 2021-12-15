/**
 * @name Test for literals
 */

import csharp

from Method m, DoubleLiteral l
where
  m.hasName("MainLiterals") and
  l.getEnclosingCallable() = m and
  l.getValue() = "4.565"
select l
