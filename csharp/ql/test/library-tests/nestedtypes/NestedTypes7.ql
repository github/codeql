/**
 * @name Test for nested types
 */

import csharp

from UnboundGenericClass o, UnboundGenericClass i
where
  o.hasQualifiedName("NestedTypes.Outer2<>") and
  i.hasQualifiedName("NestedTypes.Outer2<>.Inner2<>") and
  i = o.getANestedType() and
  i.getTypeParameter(0).getName() = o.getTypeParameter(0).getName()
select o, i
