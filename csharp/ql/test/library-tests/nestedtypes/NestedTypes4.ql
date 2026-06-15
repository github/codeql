/**
 * @name Test for nested types
 */

import csharp

from Class base, Class derived, Class nested
where
  base.hasFullyQualifiedName("NestedTypes", "Base") and
  derived.hasFullyQualifiedName("NestedTypes", "Derived") and
  nested.hasFullyQualifiedName("NestedTypes", "Derived+Nested") and
  nested.getNamespace().hasName("NestedTypes") and
  derived.getBaseClass() = base and
  derived.isInternal() and
  nested.isPublic() and
  base.isPublic()
select base, derived, nested
