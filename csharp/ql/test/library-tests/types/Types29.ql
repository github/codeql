/**
 * @name Test for pointer type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "PointerType" and
  m.getReturnType() instanceof PointerType
select m
