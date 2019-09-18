/**
 * @name Test for overrides
 */

import csharp

from Method af6, Method bf6
where
  af6.hasName("f6") and
  af6.getDeclaringType().hasName("A") and
  bf6.hasName("f6") and
  bf6.getDeclaringType().hasName("B") and
  af6.getOverridee() = bf6
select af6, bf6
