/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("Z") and
  p.getDeclaringType().hasFullyQualifiedName("Properties", "A") and
  p.isReadWrite() and
  not p.isAutoImplemented() and
  p.isAbstract() and
  p.isPublic() and
  not p.getGetter().hasBody() and
  not p.getSetter().hasBody()
select p
