/**
 * @name Test for nested types
 */

import csharp

from Class c, Struct s
where
  c.hasQualifiedName("NestedTypes.Base") and
  s.hasQualifiedName("NestedTypes.Base+S") and
  s = c.getANestedType() and
  s.(NestedType).isProtected() and
  c.isPublic()
select c, s
