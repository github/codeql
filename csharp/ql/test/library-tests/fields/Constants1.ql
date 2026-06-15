/**
 * @name Test for constants
 */

import csharp

from MemberConstant c
where
  c.getName() = "X" and
  c.getDeclaringType().hasFullyQualifiedName("Constants", "A") and
  c.getType() instanceof IntType and
  c.getInitializer() instanceof BinaryOperation and
  c.isPublic() and
  c.getValue() = "12"
select c, c.getType().toString()
