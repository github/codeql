/**
 * @name Catching by value
 * @description Catching an exception by value will create a copy of the thrown exception, thereby potentially slicing the original exception object.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cpp/catch-by-value
 * @tags efficiency
 *       correctness
 *       exceptions
 */

import cpp

from CatchBlock cb, Class caughtType
where caughtType = cb.getParameter().getUnspecifiedType()
select cb,
  "This should catch a " + caughtType.getName() + " by (const) reference rather than by value."
