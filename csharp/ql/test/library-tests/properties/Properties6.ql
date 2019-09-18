/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("Y") and
  p.getDeclaringType().hasQualifiedName("Properties.Point") and
  p.isReadWrite() and
  p.isPublic() and
  p.isAutoImplemented()
select p
