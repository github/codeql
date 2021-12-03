/**
 * @name Test for literals
 */

import csharp

from Method m, ULongLiteral l
where
  m.hasName("MainLiterals") and
  l.getEnclosingCallable() = m and
  l.getValue() = "89898787897"
select l
