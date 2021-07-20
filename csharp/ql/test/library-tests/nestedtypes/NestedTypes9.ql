/**
 * @name Test for nested types
 */

import csharp

from UnboundGenericClass o, ConstructedClass i
where
  o.hasQualifiedName("NestedTypes.Outer<>") and
  i.hasQualifiedName("NestedTypes.Outer<>+Inner<System.String>") and
  i.getUnboundGeneric() = o.getANestedType() and
  i.getTypeArgument(0) instanceof StringType
select o, i
