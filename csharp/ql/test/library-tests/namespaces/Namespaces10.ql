/**
 * @name Test for namespaces
 */

import csharp

from Namespace n, UnboundGenericClass ga, Class a
where
  n.hasQualifiedName("R1") and
  ga.hasQualifiedName("R1", "A<>") and
  ga.getATypeParameter().hasName("T") and
  ga.getNamespace() = n and
  a.hasQualifiedName("R1.A") and
  n.getAClass() = a and
  n.getAClass() = ga
select n, ga, a
