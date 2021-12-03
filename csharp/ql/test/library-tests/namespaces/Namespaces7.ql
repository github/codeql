/**
 * @name Test for namespaces
 */

import csharp

from Namespace n, Class b, Class a
where
  n.hasQualifiedName("Q3") and
  a.hasQualifiedName("Q1.Q2", "A") and
  b.hasName("B") and
  b.getNamespace() = n and
  b.getBaseClass() = a
select n, b, a
