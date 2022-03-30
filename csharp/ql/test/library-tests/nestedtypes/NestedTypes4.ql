/**
 * @name Test for nested types
 */

import csharp

from Class base, Class derived, Class nested
where
  base.hasQualifiedName("NestedTypes.Base") and
  derived.hasQualifiedName("NestedTypes.Derived") and
  nested.hasQualifiedName("NestedTypes.Derived+Nested") and
  nested.getNamespace().hasName("NestedTypes") and
  derived.getBaseClass() = base and
  derived.isInternal() and
  nested.isPublic() and
  base.isPublic()
select base, derived, nested
