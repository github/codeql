/**
 * @name Test for overrides
 */

import csharp

from Property ap2, Property bp2
where
  ap2.hasName("P2") and
  ap2.getDeclaringType().hasName("A") and
  bp2.hasName("P2") and
  bp2.getDeclaringType().hasName("B") and
  ap2.getOverridee() = bp2
select ap2, bp2
