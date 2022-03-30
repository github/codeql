/**
 * @name Test for indexers
 */

import csharp

from Indexer i
where
  i.getDeclaringType().hasQualifiedName("Indexers.Grid") and
  i.getType() instanceof IntType and
  i.getParameter(1).getName() = "col" and
  i.getParameter(1).getType() instanceof IntType
select i
