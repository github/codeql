/**
 * @name Test for overrides
 */

import csharp

from Method af4, Method bf4, Method cf4
where
  af4.hasName("f4") and
  af4.getDeclaringType().hasName("A") and
  bf4.hasName("f4") and
  bf4.getDeclaringType().hasName("B") and
  cf4.hasName("f4") and
  cf4.getDeclaringType().hasName("C") and
  not af4.getOverridee() = bf4 and
  af4.getOverridee() = cf4
select af4, bf4, cf4
