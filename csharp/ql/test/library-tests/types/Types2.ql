/**
 * @name Test for char type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "CharType" and
  m.getReturnType() instanceof CharType
select m
