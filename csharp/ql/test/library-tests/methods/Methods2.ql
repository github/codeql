/**
 * @name Test for methods
 */

import csharp

from Method s
where
  s.hasName("Divide") and
  s.isStatic() and
  s.isPublic() and
  s.getReturnType() instanceof VoidType
select s
