/**
 * @name Test for decimal type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "DecimalType" and
  m.getReturnType() instanceof DecimalType
select m
