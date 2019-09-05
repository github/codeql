/**
 * @name Parameters3
 * @kind table
 */

import cpp

from Function f, int i, Parameter p, string pname, boolean named
where
  f.hasName("Dispatch") and
  f.getParameter(i) = p and
  p.getName() = pname and
  (
    p.isNamed() and named = true
    or
    not p.isNamed() and named = false
  )
select f, i, pname, named
