/**
 * @name SourceDeclaration
 */

import default

from Class cls, Class sourceDecl
where
  cls.getPackage().hasName("generics") and
  cls.getSourceDeclaration() = sourceDecl
select cls.getLocation().getStartLine(), cls, sourceDecl.getLocation().getStartLine(), sourceDecl
