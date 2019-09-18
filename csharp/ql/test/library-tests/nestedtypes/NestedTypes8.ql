/**
 * @name Test for nested types
 */

import csharp

from ConstructedClass o, ConstructedClass i
where
  o.hasQualifiedName("NestedTypes.Outer<Int32>") and
  i.hasQualifiedName("NestedTypes.Outer<Int32>.Inner<String>") and
  i = o.getANestedType() and
  o.getTypeArgument(0) instanceof IntType and
  i.getTypeArgument(0) instanceof StringType
select o, i
