/**
 * @name Test for indexers
 */

import csharp

from Indexer i
where
  i.getDeclaringType().hasFullyQualifiedName("Indexers", "Grid") and
  i.getType() instanceof IntType and
  i.getDimension() = 2
select i
