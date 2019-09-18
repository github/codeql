/**
 * @name Test for nested types
 */

import csharp

from UnboundGenericClass o, UnboundGenericClass i
where
  o.hasQualifiedName("NestedTypes.Outer<>") and
  i.hasQualifiedName("NestedTypes.Outer<>.Inner<>") and
  i = o.getANestedType()
select o, i
