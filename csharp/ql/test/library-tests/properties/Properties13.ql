/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("Z") and
  p.getDeclaringType().hasFullyQualifiedName("Properties", "B") and
  p.isReadWrite() and
  not p.isAutoImplemented() and
  p.isOverride() and
  p.isPublic() and
  p.getGetter().hasBody() and
  p.getSetter().hasBody()
select p
