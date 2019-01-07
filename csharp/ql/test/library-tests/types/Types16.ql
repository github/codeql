/**
 * @name Test for array type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "ArrayType" and
  m.getReturnType() instanceof ArrayType
select m
