/**
 * @name Test for float type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "FloatType" and
  m.getReturnType() instanceof FloatType
select m
