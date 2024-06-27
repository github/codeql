/**
 * @name Test for namespaces
 */

import csharp

from Namespace n, Class c, Class a
where
  n.hasFullyQualifiedName("", "Q3") and
  a.hasFullyQualifiedName("Q1.Q2", "A") and
  c.hasName("C") and
  c.getNamespace() = n and
  c.getBaseClass() = a
select n, c, a
