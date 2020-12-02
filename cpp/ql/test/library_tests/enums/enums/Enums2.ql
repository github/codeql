/**
 * @name Enums2
 * @kind table
 */

import cpp

from EnumConstantAccess a, string name
where a.getTarget().getDeclaringEnum().hasName(name)
select a, name
