/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("X") and
  p.getDeclaringType().hasQualifiedName("Properties.ReadOnlyPoint") and
  p.isReadWrite() and
  p.isPublic() and
  p.isAutoImplemented() and
  p.getSetter().isPrivate()
select p
