/**
 * @name Unused label
 * @description An unused label serves no purpose and should be removed.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/unused-label
 * @tags maintainability
 *       useless-code
 */

import csharp

from LabelStmt label
where not exists(GotoLabelStmt goto | label = goto.getTarget())
select label, "This label is not used."
