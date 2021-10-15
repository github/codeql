/**
 * @name Test for literals
 */

import csharp

from Method m, DecimalLiteral l
where
  m.hasName("MainLiterals") and
  l.getEnclosingCallable() = m and
  l.getValue() = "123.456"
select l
