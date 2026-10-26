/**
 * @name Test for nested types
 */

import csharp

from Class c, Interface i
where
  c.hasFullyQualifiedName("NestedTypes", "Base") and
  i.hasFullyQualifiedName("NestedTypes", "Base+I") and
  i.(NestedType).isPrivate() and
  i = c.getANestedType()
select c, i
