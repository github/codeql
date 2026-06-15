/**
 * @name 'apply' function used
 * @description The builtin function 'apply' is obsolete and should not be used.
 * @kind problem
 * @tags maintainability
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/use-of-apply
 */

import python
private import semmle.python.ApiGraphs

from CallNode call
where
  major_version() = 2 and
  call = API::builtin("apply").getACall().asCfgNode()
select call, "Call to the obsolete builtin function 'apply'."
