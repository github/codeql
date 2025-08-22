/**
 * @name Test for fields
 */

import csharp

from Field f, Class c
where
  f.getName() = "Black" and
  f.getDeclaringType() = c and
  c.hasFullyQualifiedName("Fields", "Color") and
  f.getType() = c and
  f.isStatic() and
  f.isPublic() and
  f.isReadOnly()
select f, f.getDeclaringType()
