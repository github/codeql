/**
 * @name Test for enums
 */

import csharp

from EnumConstant c
where
  c.getName() = "Red" and
  c.getDeclaringType().hasFullyQualifiedName("Enums", "SparseColor") and
  c.getType() = c.getDeclaringType() and
  c.getValue() = "0" and
  c.getUnderlyingType() instanceof IntType and
  not c.hasExplicitValue()
select c
