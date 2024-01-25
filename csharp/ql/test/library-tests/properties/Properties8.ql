/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("X") and
  p.getDeclaringType().hasFullyQualifiedName("Properties", "A") and
  p.isReadOnly() and
  p.isVirtual()
select p
