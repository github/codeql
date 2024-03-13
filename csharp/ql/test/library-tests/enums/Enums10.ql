/**
 * @name Test for enums
 */

import csharp

from EnumConstant c, EnumConstant d
where
  c.getName() = "Blue" and
  d.hasName("AnotherBlue") and
  c.getDeclaringType().hasFullyQualifiedName("Enums", "SparseColor") and
  c.getType() = c.getDeclaringType() and
  c.getType() = d.getType() and
  c.getValue() = "11" and
  c.getValue() = d.getValue() and
  c.getUnderlyingType() instanceof IntType and
  c.getUnderlyingType() = d.getUnderlyingType() and
  not c.hasExplicitValue() and
  d.hasExplicitValue()
select c, d
