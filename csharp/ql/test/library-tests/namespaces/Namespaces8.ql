/**
 * @name Test for namespaces
 */

import csharp

from Namespace n, Class c, Class a
where
  n.hasQualifiedName("Q3") and
  a.hasQualifiedName("Q1.Q2", "A") and
  c.hasName("C") and
  c.getNamespace() = n and
  c.getBaseClass() = a
select n, c, a
