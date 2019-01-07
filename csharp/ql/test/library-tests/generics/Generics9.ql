/**
 * @name Test for generics
 */

import csharp

from ConstructedClass bString, Property p
where
  bString.hasName("B<String>") and
  p.getDeclaringType() = bString and
  p.hasName("Name") and
  p.getSourceDeclaration().getDeclaringType() = p.getDeclaringType().getSourceDeclaration() and
  p.getSetter().getParameter(0).getType() instanceof StringType and
  p.getSetter().getSourceDeclaration() = p.getSourceDeclaration().getSetter() and
  p.getGetter().getSourceDeclaration() = p.getSourceDeclaration().getGetter()
select bString, p.getSourceDeclaration().getSetter(), p.getSetter()
