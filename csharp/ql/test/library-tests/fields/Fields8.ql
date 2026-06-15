/**
 * @name Test for fields
 */

import csharp

from Field f, UnboundGenericClass c
where
  f.getName() = "count" and
  f.getDeclaringType() = c and
  c.hasFullyQualifiedName("Fields", "C`1") and
  f.getType() instanceof IntType and
  f.isStatic()
select f, f.getDeclaringType()
