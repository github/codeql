/**
 * @name Test for namespaces
 */

import csharp

from Namespace n
where
  n.hasFullyQualifiedName("P1", "P2") and
  n.getAClass().hasName("A") and
  n.getAClass().hasName("B") and
  n.getAStruct().hasName("S") and
  n.getAnInterface().hasName("I")
select n
