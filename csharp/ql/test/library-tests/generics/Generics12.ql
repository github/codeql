/**
 * @name Test for generics
 */

import csharp

from ConstructedClass gridInt, Indexer i
where
  gridInt.hasName("Grid<Int32>") and
  i.getDeclaringType() = gridInt and
  i.getSourceDeclaration().getDeclaringType() = i.getDeclaringType().getSourceDeclaration() and
  i.getGetter().getSourceDeclaration() = i.getSourceDeclaration().getGetter() and
  i.getSetter().getSourceDeclaration() = i.getSourceDeclaration().getSetter()
select gridInt, i
