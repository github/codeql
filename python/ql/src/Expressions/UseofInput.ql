/**
 * @name 'input' function used in Python 2
 * @description The built-in function 'input' is used which, in Python 2, can allow arbitrary code to be run.
 * @kind problem
 * @tags security
 *       correctness
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @id py/use-of-input
 */

import python

from CallNode call, Context context, ControlFlowNode func
where
  context.getAVersion().includes(2, _) and
  call.getFunction() = func and
  func.pointsTo(context, Value::named("input"), _) and
  not func.pointsTo(context, Value::named("raw_input"), _)
select call, "The unsafe built-in function 'input' is used in Python 2."
