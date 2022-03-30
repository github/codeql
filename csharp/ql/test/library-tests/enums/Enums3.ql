/**
 * @name Test for enums
 */

import csharp

from EnumConstant c
where
  c.getName() = "Green" and
  c.getDeclaringType().hasQualifiedName("Enums.LongColor") and
  c.getType() = c.getDeclaringType() and
  c.getValue() = "1"
select c, c.getDeclaringType().getBaseClass().getQualifiedName()
