/**
 * @name Test for enums
 */

import csharp

from EnumConstant c
where
  c.getName() = "Red" and
  c.getDeclaringType().hasFullyQualifiedName("Enums", "Color")
select c, c.getType()
