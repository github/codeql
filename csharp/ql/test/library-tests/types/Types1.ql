/**
 * @name Test for bool type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "BoolType" and
  m.getReturnType() instanceof BoolType
select m
