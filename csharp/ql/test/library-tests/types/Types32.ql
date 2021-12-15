/**
 * @name Test for linking constructed types to unbound generic types
 * @kind table
 */

import csharp

from Method m, ConstructedClass t, UnboundGenericClass u
where
  m.getName() = "Map" and
  m.getReturnType() = t and
  t.getUnboundGeneric() = u
select t, u
