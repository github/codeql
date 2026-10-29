/**
 * @name Test for enums
 */

import csharp

from Enum e
where
  e.hasName("E") and
  e.getUnderlyingType() instanceof LongType
select e
