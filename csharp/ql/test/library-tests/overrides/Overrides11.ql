/**
 * @name Test for overrides
 */

import csharp

from Property ap1, Property bp1
where
  ap1.hasName("P1") and
  ap1.getDeclaringType().hasName("A") and
  bp1.hasName("P1") and
  bp1.getDeclaringType().hasName("B") and
  ap1.getOverridee() = bp1
select ap1, bp1
