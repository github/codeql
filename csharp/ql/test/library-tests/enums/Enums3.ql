/**
 * @name Test for enums
 */

import csharp

from EnumConstant c, string qualifier, string name
where
  c.getName() = "Green" and
  c.getDeclaringType().hasQualifiedName("Enums", "LongColor") and
  c.getType() = c.getDeclaringType() and
  c.getValue() = "1" and
  c.getDeclaringType().getBaseClass().hasQualifiedName(qualifier, name)
select c, printQualifiedName(qualifier, name)
