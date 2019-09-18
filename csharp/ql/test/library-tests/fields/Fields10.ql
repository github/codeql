/**
 * @name Test for fields
 */

import csharp

from Field f, SimpleType t
where
  f.getName() = "MaxValue" and
  f.getDeclaringType() = t and
  t.hasQualifiedName("System.Decimal") and
  f.isPublic()
select f.toString(), f.getDeclaringType().toString()
