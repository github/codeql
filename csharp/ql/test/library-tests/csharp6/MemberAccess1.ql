/**
 * @name Tests member access
 */

import csharp

from MemberAccess ma, string conditional
where
  ma.isConditional() and conditional = "Conditional"
  or
  not ma.isConditional() and conditional = "Unconditional"
select ma, ma.getQualifier(), conditional
