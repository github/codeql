/**
 * @name Test for properties
 */

import csharp

from Property p, Field f
where
  p.hasName("Caption") and
  p.isReadWrite() and
  p.isPublic() and
  f.isPrivate() and
  f.getType() instanceof StringType and
  p.getType() = f.getType() and
  p.getDeclaringType() = f.getDeclaringType() and
  p.getGetter().getStatementBody().getStmt(0) instanceof ReturnStmt
select p, f
