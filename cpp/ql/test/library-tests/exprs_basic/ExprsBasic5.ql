/**
 * @name ExprsBasic5
 * @kind table
 */

import cpp

from Function f, VariableAccess va, GlobalVariable v
where
  f.hasName("set_current_foo") and
  va.getEnclosingFunction() = f and
  v.hasName("current_foo") and
  va.getTarget() = v
select va
