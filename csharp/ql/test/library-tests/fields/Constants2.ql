/**
 * @name Test for constants
 */

import csharp

from MemberConstant c
where
  c.getName() = "Y" and
  c.getDeclaringType().hasQualifiedName("Constants.A") and
  c.getType() instanceof IntType and
  c.getInitializer() instanceof IntLiteral and
  c.isPublic() and
  c.getValue() = "10"
select c, c.getType().toString()
