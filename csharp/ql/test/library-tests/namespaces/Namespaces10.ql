/**
 * @name Test for namespaces
 */

import csharp

from Namespace n, UnboundGenericClass ga, Class a
where
  n.hasFullyQualifiedName("", "R1") and
  ga.hasFullyQualifiedName("R1", "A`1") and
  ga.getATypeParameter().hasName("T") and
  ga.getNamespace() = n and
  a.hasFullyQualifiedName("R1", "A") and
  n.getAClass() = a and
  n.getAClass() = ga
select n, ga, a
