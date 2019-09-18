/**
 * @name Test for overrides
 */

import csharp

from Method af5, Method bf5
where
  af5.hasName("f5") and
  af5.getDeclaringType().hasName("A") and
  bf5.hasName("f5") and
  bf5.getDeclaringType().hasName("B") and
  af5.getOverridee() = bf5
select af5, bf5
