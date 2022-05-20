/**
 * @name Test for exactly one body per source method
 */

import csharp

where
  forall(Method m |
    m.fromSource() and
    not m.isAbstract() and
    not m.isExtern()
  |
    count(m.getBody()) = 1
  )
select 1
