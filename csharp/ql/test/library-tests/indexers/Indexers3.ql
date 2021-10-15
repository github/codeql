/**
 * @name Test for indexers
 */

import csharp

from Indexer i
where
  i.getDeclaringType().hasQualifiedName("Indexers.BitArray") and
  i.getType() instanceof BoolType and
  i.getParameter(0).getName() = "index" and
  i.getParameter(0).getType() instanceof IntType
select i
