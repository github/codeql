/**
 * @name Test for constructed class type
 * @kind table
 */

import csharp

from Method m
where
  m.getName() = "ConstructedClassType" and
  m.getReturnType() instanceof ConstructedClass
select m
