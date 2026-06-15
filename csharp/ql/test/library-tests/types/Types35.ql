/**
 * @name Test for binding nullable types
 * @kind table
 */

import csharp

from Method m, NullableType t1, Struct t2
where
  m.getName() = "NullableType" and
  m.getReturnType() = t1 and
  t1.getUnderlyingType() = t2 and
  t2.hasFullyQualifiedName("Types", "Struct")
select t1
