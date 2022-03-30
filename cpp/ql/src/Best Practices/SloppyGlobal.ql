/**
 * @name Short global name
 * @description Global variables should have descriptive names, to help document their use, avoid namespace pollution and reduce the risk of shadowing with local variables.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cpp/short-global-name
 * @tags maintainability
 */

import cpp

from GlobalVariable gv
where
  gv.getName().length() <= 3 and
  not gv.isStatic()
select gv,
  "Poor global variable name '" + gv.getName() +
    "'. Prefer longer, descriptive names for globals (eg. kMyGlobalConstant, not foo)."
