/**
 * @name Test for generics
 */

import csharp

from ConstructedClass c, UnboundGenericClass d
where
  c.hasName("A<X>") and
  d.hasName("A<>") and
  c.getTypeArgument(0).hasName("X") and
  c.getTypeArgument(0) instanceof TypeParameter and
  c.getUnboundGeneric() = d
select c, d
