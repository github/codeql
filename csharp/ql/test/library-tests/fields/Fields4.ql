/**
 * @name Test for fields
 */

import csharp

from Field f
where
  f.getName() = "X" and
  f.getDeclaringType().hasFullyQualifiedName("Fields", "B") and
  f.getType() instanceof IntType and
  f.getInitializer().(IntLiteral).getValue() = "1" and
  f.isPublic() and
  f.isStatic()
select f, f.getType().toString()
