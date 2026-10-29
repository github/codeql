/**
 * @name Test for sbyte type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "SByteType" and
  m.getReturnType() instanceof SByteType
select m
