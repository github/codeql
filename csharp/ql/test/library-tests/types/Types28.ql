/**
 * @name Test for delegate type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "DelegateType" and
  m.getReturnType() instanceof DelegateType
select m
