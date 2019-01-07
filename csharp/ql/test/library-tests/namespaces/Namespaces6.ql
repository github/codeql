/**
 * @name Test for namespaces
 */

import csharp

from Namespace n, Namespace p
where
  n.hasQualifiedName("Q1.Q2") and
  n.hasName("Q2") and
  p = n.getParentNamespace() and
  p.hasName("Q1") and
  p.hasQualifiedName("Q1")
select p, n
