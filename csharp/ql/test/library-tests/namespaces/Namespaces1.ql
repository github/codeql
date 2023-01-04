/**
 * @name Test for namespaces
 */

import csharp

from Namespace n
where
  n.hasQualifiedName("N1", "N2") and
  n.getAClass().hasName("A") and
  n.getAClass().hasName("B")
select n
