/**
 * @name Test for void type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "VoidType" and
  m.getReturnType() instanceof VoidType
select m
