/**
 * @name Test for ushort type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "UShortType" and
  m.getReturnType() instanceof UShortType
select m
