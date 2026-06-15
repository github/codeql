/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("Next") and
  p.isReadOnly() and
  p.isPublic() and
  p.getGetter().hasBody() and
  p.getDeclaringType().hasFullyQualifiedName("Properties", "Counter") and
  not exists(p.getSetter())
select p, p.getGetter()
