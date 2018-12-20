/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("X") and
  p.getDeclaringType().hasQualifiedName("Properties.B") and
  p.isReadOnly() and
  not p.isAutoImplemented() and
  p.isOverride() and
  p.isPublic()
select p
