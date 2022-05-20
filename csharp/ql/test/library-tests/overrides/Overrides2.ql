/**
 * @name Test for overrides
 */

import csharp

from Method bf3, Method cf3
where
  bf3.hasName("f3") and
  bf3.getDeclaringType().hasName("B") and
  cf3.hasName("f3") and
  cf3.getDeclaringType().hasName("C") and
  not bf3.getOverridee() = cf3
select bf3, cf3
