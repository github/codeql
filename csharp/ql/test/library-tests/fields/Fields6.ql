/**
 * @name Test for fields
 */

import csharp

from Field f
where
  f.getName() = "finished" and
  f.getDeclaringType().hasFullyQualifiedName("Fields", "Application") and
  f.getType() instanceof BoolType and
  not exists(f.getInitializer()) and
  f.isPublic() and
  f.isStatic() and
  f.isVolatile()
select f, f.getType().toString()
