/**
 * @name Test for enums
 */

import csharp

from EnumConstant c
where
  c.getName() = "FourBlue" and
  c.getDeclaringType().hasFullyQualifiedName("Enums", "ValueColor") and
  c.getType() = c.getDeclaringType() and
  c.getValue() = "4" and
  c.getUnderlyingType() instanceof UIntType
select c
