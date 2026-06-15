/**
 * @name Test for constants
 */

import csharp

from MemberConstant c
where
  c.getName() = "Z" and
  c.getDeclaringType().hasFullyQualifiedName("Constants", "B") and
  c.getType() instanceof IntType and
  c.getInitializer() instanceof BinaryOperation and
  c.isPublic() and
  c.getValue() = "11"
select c, c.getType().toString()
