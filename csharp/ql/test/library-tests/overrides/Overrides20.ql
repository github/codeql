/**
 * @name Test for overrides
 */

import csharp

from Property p1, Property p2
where
  (p1.getOverridee() = p2 or p1.getImplementee() = p2) and
  p2.hasName("Prop")
select p1, p2
