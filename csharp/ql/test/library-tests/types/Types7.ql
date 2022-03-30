/**
 * @name Test for long type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "LongType" and
  m.getReturnType() instanceof LongType
select m
