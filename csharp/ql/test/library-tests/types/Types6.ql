/**
 * @name Test for int type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "IntType" and
  m.getReturnType() instanceof IntType
select m
