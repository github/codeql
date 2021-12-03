/**
 * @name Test for overrides
 */

import csharp

from Method bf5, Method cf5
where
  bf5.hasName("f5") and
  bf5.getDeclaringType().hasName("B") and
  cf5.hasName("f5") and
  cf5.getDeclaringType().hasName("C") and
  bf5.getOverridee() = cf5
select bf5, cf5
