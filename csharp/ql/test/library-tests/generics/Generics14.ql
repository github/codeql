/**
 * @name Test for generics
 */

import csharp

from UnboundGenericClass gridInt, Indexer i
where
  gridInt.hasName("Grid<>") and
  i.getDeclaringType() = gridInt and
  i.getType() instanceof IntType
select gridInt, i
