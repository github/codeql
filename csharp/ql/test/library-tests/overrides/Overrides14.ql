/**
 * @name Test for overrides
 */

import csharp

from Property ap4, Property bp4, Property cp4
where
  ap4.hasName("P4") and
  ap4.getDeclaringType().hasName("A") and
  bp4.hasName("P4") and
  bp4.getDeclaringType().hasName("B") and
  cp4.hasName("P4") and
  cp4.getDeclaringType().hasName("C") and
  not ap4.getOverridee() = bp4 and
  ap4.getOverridee() = cp4
select ap4, bp4
