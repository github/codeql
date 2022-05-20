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
private import semmle.python.types.Builtins

from CallNode call, ControlFlowNode func
where major_version() = 2 and call.getFunction() = func and func.pointsTo(Value::named("apply"))
select call, "Call to the obsolete builtin function 'apply'."
