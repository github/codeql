/**
 * @name Test for generics
 */

import csharp

from ConstructedClass at, UnboundGenericClass b, ConstructedClass bt, Field f
where
  at.hasName("A<T>") and
  b.hasName("B<>") and
  bt.hasName("B<X>") and
  at.getTypeArgument(0).hasName("T") and
  at.getTypeArgument(0) instanceof TypeParameter and
  at.getTypeArgument(0) = b.getTypeParameter(0) and
  bt.getUnboundGeneric() = b and
  f.getDeclaringType() = b and
  f.getType() = at
select b, bt, f, at
