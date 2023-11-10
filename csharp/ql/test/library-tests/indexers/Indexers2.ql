/**
 * @name Test for indexers
 */

import csharp

from Indexer i
where
  i.getDeclaringType().hasFullyQualifiedName("Indexers", "BitArray") and
  i.getType() instanceof BoolType and
  i.getDimension() = 1
select i
