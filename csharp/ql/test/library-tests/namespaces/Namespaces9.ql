/**
 * @name Test for namespaces
 */

import csharp

from UnboundGenericClass a, Class b
where
  a.hasFullyQualifiedName("R1", "A`1") and
  a.getATypeParameter().hasName("T") and
  a.getANestedType() = b and
  b.getName() = "B" and
  b.hasFullyQualifiedName("R1", "A`1+B")
select a, b
