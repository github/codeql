/**
 * @name Test for overrides
 */

import csharp

from Method af2, Method bf2
where
  af2.hasName("f2") and
  af2.getDeclaringType().hasName("A") and
  af2.hasName("f2") and
  bf2.getDeclaringType().hasName("B") and
  af2.getOverridee() = bf2
select af2, bf2
