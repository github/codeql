/**
 * @name Test for overrides
 */

import csharp

from Method af1, Method bf1
where
  af1.hasName("f1") and
  af1.getDeclaringType().hasName("A") and
  bf1.hasName("f1") and
  bf1.getDeclaringType().hasName("B") and
  not af1.getOverridee() = bf1
select af1, bf1
