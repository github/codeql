/**
 * @name Calls1
 * @kind table
 */

import cpp

from Function a, string rel, Function b
where
  a.accesses(b) and rel = "accesses"
  or
  a.calls(b) and rel = "calls"
select a.getName(), rel, b.getName()
