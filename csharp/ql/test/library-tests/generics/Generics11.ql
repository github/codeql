/**
 * @name Test for generics
 */

import csharp

from ConstructedClass bString, Operator o
where
  bString.hasName("B<String>") and
  o.getDeclaringType() = bString and
  o instanceof IncrementOperator and
  o.getSourceDeclaration().getDeclaringType() = o.getDeclaringType().getSourceDeclaration()
select bString, o
