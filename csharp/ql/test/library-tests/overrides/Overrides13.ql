/**
 * @name Test for overrides
 */

import csharp

from Property ap3, Property bp3
where
  ap3.hasName("P3") and
  ap3.getDeclaringType().hasName("A") and
  bp3.hasName("P3") and
  bp3.getDeclaringType().hasName("B") and
  ap3.getOverridee() = bp3
select ap3, bp3
