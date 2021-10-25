/**
 * @name Test for indexers
 */

import csharp

from Class c
where
  c.hasQualifiedName("Indexers.BitArray") and
  count(Indexer i | i.getDeclaringType() = c) = 1
select c
