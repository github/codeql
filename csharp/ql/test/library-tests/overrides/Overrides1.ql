/**
 * @name Test for overrides
 */

import csharp

from Method bf2, Method cf2
where
  bf2.hasName("f2") and
  bf2.getDeclaringType().hasName("B") and
  cf2.hasName("f2") and
  cf2.getDeclaringType().hasName("C") and
  not bf2.getOverridee() = cf2
select bf2, cf2
