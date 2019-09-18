/**
 * @name Test for generics
 */

import csharp

from ConstructedClass bString, Event e
where
  bString.hasName("B<String>") and
  e.getDeclaringType() = bString and
  e.hasName("myEvent") and
  e.getSourceDeclaration().getDeclaringType() = e.getDeclaringType().getSourceDeclaration() and
  e.getType().(ConstructedDelegateType).getTypeArgument(0) instanceof StringType and
  e.getAddEventAccessor().getSourceDeclaration() = e.getSourceDeclaration().getAddEventAccessor() and
  e.getRemoveEventAccessor().getSourceDeclaration() = e
        .getSourceDeclaration()
        .getRemoveEventAccessor()
select bString, e
