/**
 * @name Test for indexers
 */

import csharp

from Indexer i
where
  i.getDeclaringType().hasQualifiedName("Indexers.BitArray") and
  i.getType() instanceof BoolType and
  i.getGetter().hasBody() and
  i.getSetter().hasBody()
select i
