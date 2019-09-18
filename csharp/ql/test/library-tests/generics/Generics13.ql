/**
 * @name Test for generics
 */

import csharp

from ConstructedClass gridInt, Indexer i
where
  gridInt.hasName("Grid<Int32>") and
  i.getDeclaringType() = gridInt and
  i.getType() instanceof IntType
select gridInt, i
