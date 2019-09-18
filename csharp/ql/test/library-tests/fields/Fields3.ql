/**
 * @name Test for fields
 */

import csharp

from Field f
where
  f.getName() = "Z" and
  f.getDeclaringType().hasQualifiedName("Fields.A") and
  f.getType() instanceof IntType and
  f.getInitializer().(IntLiteral).getValue() = "100" and
  f.isPublic() and
  f.isStatic()
select f, f.getType().toString()
