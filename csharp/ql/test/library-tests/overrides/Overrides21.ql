/**
 * @name Test for overrides
 */

import csharp

from MethodCall mc, Method m
where
  mc.getTarget() = m and
  m.fromSource()
select mc, m
