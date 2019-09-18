/**
 * @name Test for literals
 */

import csharp

from Method m, UIntLiteral l
where
  m.hasName("MainLiterals") and
  l.getEnclosingCallable() = m and
  l.getValue() = "3"
select l
