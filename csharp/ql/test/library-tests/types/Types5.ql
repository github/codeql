/**
 * @name Test for short type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "ShortType" and
  m.getReturnType() instanceof ShortType
select m
