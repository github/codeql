/**
 * @name Test for indexers
 */

import csharp

from Indexer i
where
  i.getDeclaringType().hasQualifiedName("Indexers.Grid") and
  i.getType() instanceof IntType and
  i.isPublic() and
  i.isReadWrite()
select i
