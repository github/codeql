/**
 * @name Tests conditional method calls
 */

import csharp

from MethodCall mc, string conditional
where
  mc.isConditional() and conditional = "Conditional"
  or
  not mc.isConditional() and conditional = "Unconditional"
select mc, mc.getQualifier(), conditional
