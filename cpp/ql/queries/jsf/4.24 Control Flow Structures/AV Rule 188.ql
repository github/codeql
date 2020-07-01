/**
 * @name AV Rule 188
 * @description Labels will not be used, except in switch statements.
 * @kind problem
 * @id cpp/jsf/av-rule-188
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

from LabelStmt l
where not exists(GotoStmt g | g.breaksFromNestedLoops() and g.getTarget() = l)
select l, "AV Rule 188: Labels will not be used, except in switch statements."
