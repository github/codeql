/**
 * @name Test for nested types
 */

import csharp

from Class c, Interface i
where
  c.hasQualifiedName("NestedTypes.Base") and
  i.hasQualifiedName("NestedTypes.Base.I") and
  i.(NestedType).isPrivate() and
  i = c.getANestedType()
select c, i
