/**
 * @name Test for methods
 */

import csharp

from Method s
where
  s.hasName("Swap") and
  s.isStatic() and
  s.fromSource()
select s
