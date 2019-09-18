/**
 * @name Test for constructed struct type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "ConstructedStructType" and
  m.getReturnType() instanceof ConstructedStruct
select m
