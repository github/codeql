/**
 * @name Test for namespaces
 */

import csharp

from Namespace n, Class b, Class a
where
  n.hasFullyQualifiedName("", "Q3") and
  a.hasFullyQualifiedName("Q1.Q2", "A") and
  b.hasName("B") and
  b.getNamespace() = n and
  b.getBaseClass() = a
select n, b, a
