/**
 * @name Test for delegates
 */

import csharp

from DelegateType d
where
  d.hasName("FooDelegate") and
  d.getNumberOfParameters() = 3
select d
