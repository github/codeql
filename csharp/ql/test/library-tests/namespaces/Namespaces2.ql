/**
 * @name Test for namespaces
 */

import csharp

from Namespace n
where
  n.hasFullyQualifiedName("M1", "M2") and
  n.getAClass().hasName("A") and
  n.getAClass().hasName("B")
select n
