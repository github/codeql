/**
 * @name Test for generics
 */

import csharp

from ConstructedClass bString, Method m
where
  bString.hasName("B<String>") and
  m.getDeclaringType() = bString and
  m.hasName("fooParams") and
  m.getParameter(0).getType().(ArrayType).getElementType() instanceof StringType and
  m.getSourceDeclaration().getDeclaringType() = m.getDeclaringType().getSourceDeclaration()
select bString, m
