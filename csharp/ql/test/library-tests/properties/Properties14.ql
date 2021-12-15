/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("Count") and
  p.getDeclaringType().hasQualifiedName("System.Collections.Generic.List<>") and
  not p.isAutoImplemented() and
  not p.isStatic() and
  p.isPublic() and
  p.getType() instanceof IntType
select p.toString()
