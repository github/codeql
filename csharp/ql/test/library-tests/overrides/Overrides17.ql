/**
 * @name Test for overrides
 */

import csharp

from Event ae1, Event be1
where
  ae1.hasName("E1") and
  ae1.getDeclaringType().hasName("A") and
  be1.hasName("E1") and
  be1.getDeclaringType().hasName("B") and
  ae1.getOverridee() = be1
select ae1, be1
