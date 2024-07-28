/**
 * @name Test for indexers
 */

import csharp

from Indexer i
where
  i.getDeclaringType().hasFullyQualifiedName("Indexers", "Grid") and
  i.getType() instanceof IntType and
  i.isPublic() and
  i.isReadWrite()
select i
