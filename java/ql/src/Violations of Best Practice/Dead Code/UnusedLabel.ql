/**
 * @name Unused label
 * @description An unused label for a loop or 'switch' statement is either redundant or indicates
 *              incorrect 'break' or 'continue' statements.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/unused-label
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import java

from LabeledStmt label
where not exists(JumpStmt jump | jump.getTargetLabel() = label)
select label, "Label '" + label.getLabel() + "' is not used."
