/**
 * @name Test for overrides
 */

import csharp

from Method bf4, Method cf4
where
  bf4.hasName("f4") and
  bf4.getDeclaringType().hasName("B") and
  cf4.hasName("f4") and
  cf4.getDeclaringType().hasName("C") and
  not bf4.getOverridee() = cf4
select bf4, cf4
