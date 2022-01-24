/**
 * @name Test for nested types
 */

import csharp

from Class c, DelegateType d
where
  c.hasQualifiedName("NestedTypes.Base") and
  d.hasQualifiedName("NestedTypes.Base+MyDelegate") and
  d.(NestedType).isPrivate() and
  d = c.getANestedType()
select c, d
