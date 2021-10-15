/**
 * @name Test for double type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "DoubleType" and
  m.getReturnType() instanceof DoubleType
select m
