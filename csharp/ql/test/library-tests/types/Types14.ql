/**
 * @name Test for nullable type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "NullableType" and
  m.getReturnType() instanceof NullableType
select m
