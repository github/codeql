/**
 * @name Test for generics
 */

import csharp

from ConstructedClass aString, ConstructedClass bString
where
  aString.hasName("A<String>") and
  bString.hasName("B<String>") and
  aString.getSourceDeclaration().hasName("A<>") and
  bString.getSourceDeclaration().hasName("B<>")
select aString, bString
