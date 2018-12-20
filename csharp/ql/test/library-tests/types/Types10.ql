/**
 * @name Test for uint type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "UIntType" and
  m.getReturnType() instanceof UIntType
select m
