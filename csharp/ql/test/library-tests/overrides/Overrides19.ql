/**
 * @name Test for overrides
 */

import csharp

from Method m, Method m2
where
  (m.getName() = "M" or m.getName() = "M<>") and
  (m.getOverridee() = m2 or m.getImplementee() = m2)
select m, m.getDeclaringType(), m2, m2.getDeclaringType()
