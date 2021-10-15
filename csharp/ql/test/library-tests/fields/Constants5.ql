/**
 * @name Count of accesses to constant
 */

import csharp

from MemberConstant c
where c.getDeclaringType().getNamespace().getName().matches("%Constants%")
select c, c.getAnAccess() as a, a.getLocation().getStartLine()
