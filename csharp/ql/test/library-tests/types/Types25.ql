/**
 * @name Test for constructed interface type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "ConstructedInterfaceType" and
  m.getReturnType() instanceof ConstructedInterface
select m
