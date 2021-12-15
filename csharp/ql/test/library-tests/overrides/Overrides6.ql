/**
 * @name Test for overrides
 */

import csharp

from Method af3, Method bf3
where
  af3.hasName("f3") and
  af3.getDeclaringType().hasName("A") and
  bf3.hasName("f3") and
  bf3.getDeclaringType().hasName("B") and
  af3.getOverridee() = bf3
select af3, bf3
