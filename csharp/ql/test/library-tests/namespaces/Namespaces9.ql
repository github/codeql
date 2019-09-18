/**
 * @name Test for namespaces
 */

import csharp

from UnboundGenericClass a, Class b
where
  a.hasQualifiedName("R1", "A<>") and
  a.getATypeParameter().hasName("T") and
  a.getANestedType() = b and
  b.getName() = "B" and
  b.hasQualifiedName("R1.A<>.B")
select a, b
