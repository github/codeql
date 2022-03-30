/**
 * @name Test for enums
 */

import csharp

from EnumConstant c
where
  c.getName() = "Green" and
  c.getDeclaringType().hasQualifiedName("Enums.Color") and
  c.getType() = c.getDeclaringType() and
  c.getUnderlyingType() instanceof IntType
select c
