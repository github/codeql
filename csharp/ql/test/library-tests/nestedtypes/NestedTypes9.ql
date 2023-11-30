/**
 * @name Test for nested types
 */

import csharp

from UnboundGenericClass o, ConstructedClass i
where
  o.hasFullyQualifiedName("NestedTypes", "Outer`1") and
  i.hasFullyQualifiedName("NestedTypes", "Outer`1+Inner<System.String>") and
  i.getUnboundGeneric() = o.getANestedType() and
  i.getTypeArgument(0) instanceof StringType
select o, i
