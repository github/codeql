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
import semmle.code.cpp.ConfigurationTestFile

from GlobalVariable gv
where
  gv.getName().length() <= 3 and
  not gv.isStatic() and
  not gv.getFile() instanceof ConfigurationTestFile // variables in files generated during configuration are likely false positives
select gv,
  "Poor global variable name '" + gv.getName() +
    "'. Prefer longer, descriptive names for globals (eg. kMyGlobalConstant, not foo)."
