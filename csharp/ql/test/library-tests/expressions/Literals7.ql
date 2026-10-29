/**
 * @name Test for literals
 */

import csharp

from Method m, FloatLiteral l
where
  m.hasName("MainLiterals") and
  l.getEnclosingCallable() = m and
  l.getValue() = "4.5"
select l
