/**
 * @name Test for indexers
 */

import csharp

from Indexer i
where
  i.getDeclaringType().hasFullyQualifiedName("Indexers", "Grid") and
  i.getType() instanceof IntType and
  i.getParameter(0).getName() = "c" and
  i.getParameter(0).getType() instanceof CharType
select i
