/**
 * @name Test for ulong type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "ULongType" and
  m.getReturnType() instanceof ULongType
select m
