/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("X") and
  p.getDeclaringType().hasFullyQualifiedName("Properties", "Point") and
  p.isReadWrite() and
  p.isPublic() and
  exists(p.getGetter()) and
  not p.getGetter().hasBody() and
  exists(p.getSetter()) and
  not p.getSetter().hasBody()
select p
