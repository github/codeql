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

from CallNode call, ControlFlowNode func
where
major_version() = 2 and call.getFunction() = func and func.refersTo(Object::builtin("apply"))
select call, "Call to the obsolete builtin function 'apply'."
