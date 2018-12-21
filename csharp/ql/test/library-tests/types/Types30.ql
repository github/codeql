/**
 * @name Test for type parameter type
 * @kind table
 */

import csharp

from UnboundGenericClass c, TypeParameter p1, TypeParameter p2
where
  c.getQualifiedName() = "Types.Map<,>" and
  c.getTypeParameter(0) = p1 and
  c.getTypeParameter(1) = p2 and
  p1.getName() = "U" and
  p2.getName() = "V"
select c, p1, p2
