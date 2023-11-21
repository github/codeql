/**
 * @name Test for nested types
 */

import csharp

from Class c, DelegateType d
where
  c.hasFullyQualifiedName("NestedTypes", "Base") and
  d.hasFullyQualifiedName("NestedTypes", "Base+MyDelegate") and
  d.(NestedType).isPrivate() and
  d = c.getANestedType()
select c, d
