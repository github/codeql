/**
 * @name Test for nested types
 */

import csharp

from Class base, Class derived, Class nested
where
  base.hasQualifiedName("NestedTypes.Base") and
  derived.hasQualifiedName("NestedTypes.Derived") and
  nested.hasQualifiedName("NestedTypes.Derived.Nested") and
  nested.getNamespace().hasName("NestedTypes") and
  nested.getDeclaringType() = derived
select base, derived, nested
