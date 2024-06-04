/**
 * @name Test for namespaces
 */

import csharp

from Namespace n, Namespace p
where
  n.hasFullyQualifiedName("Q1", "Q2") and
  n.hasName("Q2") and
  p = n.getParentNamespace() and
  p.hasName("Q1") and
  p.hasFullyQualifiedName("", "Q1")
select p, n
