/**
 * @name Test for nested types
 */

import csharp

from UnboundGenericClass o, UnboundGenericClass i
where
  o.hasFullyQualifiedName("NestedTypes", "Outer2`1") and
  i.hasFullyQualifiedName("NestedTypes", "Outer2`1+Inner2`1") and
  i = o.getANestedType() and
  i.getTypeParameter(0).getName() = o.getTypeParameter(0).getName()
select o, i
