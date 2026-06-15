/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("Y") and
  p.getDeclaringType().hasFullyQualifiedName("Properties", "A") and
  p.isReadWrite() and
  not p.isAutoImplemented() and
  p.isVirtual() and
  p.isPublic()
select p
