/**
 * @name Test for enums
 */

import csharp

from EnumConstant c
where
  c.getName() = "Green" and
  c.getDeclaringType().hasFullyQualifiedName("Enums", "SparseColor") and
  c.getType() = c.getDeclaringType() and
  c.getValue() = "10" and
  c.getUnderlyingType() instanceof IntType and
  c.hasExplicitValue()
select c
