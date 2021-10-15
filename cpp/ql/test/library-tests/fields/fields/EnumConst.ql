/**
 * @name EnumConst
 * @kind table
 */

import cpp

from Enum e, Declaration c, string reason
where
  c.(EnumConstant).getDeclaringEnum() = e and reason = "getDeclaringEnum()"
  or
  c.(EnumConstant).getType() = e and reason = "getType()"
  or
  c.(Field).getDeclaringType() = e and reason = "getDeclaringType()"
select e, c, reason
