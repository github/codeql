/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("Y") and
  p.getDeclaringType().hasFullyQualifiedName("Properties", "B") and
  p.isReadWrite() and // overrides a property that is readwrite
  not p.isAutoImplemented() and
  p.isOverride() and
  p.isPublic()
select p
