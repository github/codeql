/**
 * @name Test for nested types
 */

import csharp

from UnboundGenericClass o, UnboundGenericClass i
where
  o.hasFullyQualifiedName("NestedTypes", "Outer`1") and
  i.hasFullyQualifiedName("NestedTypes", "Outer`1+Inner`1") and
  i = o.getANestedType()
select o, i
