/**
 * @name Test for nested types
 */

import csharp

from ConstructedClass o, ConstructedClass i
where
  o.hasFullyQualifiedName("NestedTypes", "Outer<System.Int32>") and
  i.hasFullyQualifiedName("NestedTypes", "Outer<System.Int32>+Inner<System.String>") and
  i = o.getANestedType() and
  o.getTypeArgument(0) instanceof IntType and
  i.getTypeArgument(0) instanceof StringType
select o, i
