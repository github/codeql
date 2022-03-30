/**
 * @name Continue statement that does not continue
 * @description A 'continue' statement only re-runs the loop if the
 *              loop-condition is true. Therefore using 'continue' in a loop
 *              with a constant false condition is misleading and usually a
 *              bug.
 * @kind problem
 * @id java/continue-in-false-loop
 * @problem.severity warning
 * @precision high
 * @tags correctness
 */

import java

from DoStmt do, ContinueStmt continue
where
  do.getCondition().(BooleanLiteral).getBooleanValue() = false and
  continue.(JumpStmt).getTarget() = do
select continue, "This 'continue' never re-runs the loop - the $@ is always false.",
  do.getCondition(), "loop condition"
