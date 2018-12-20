/**
 * @name Test for indexers
 */

import csharp

from Indexer i
where
  i.getDeclaringType().hasQualifiedName("Indexers.Grid") and
  i.getType() instanceof IntType and
  i.getDimension() = 2
select i
