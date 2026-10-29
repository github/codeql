/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("Count") and
  p.getDeclaringType().hasFullyQualifiedName("System.Collections.Generic", "List`1") and
  not p.isAutoImplemented() and
  not p.isStatic() and
  p.isPublic() and
  p.getType() instanceof IntType
select p.toString()
