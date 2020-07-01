/**
 * @name AV Rule 190
 * @description The continue statement shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-190
 * @problem.severity recommendation
 * @tags maintainability
 *       external/jsf
 */

import cpp

from ContinueStmt s
where s.fromSource()
select s, "AV Rule 190: The continue statement shall not be used."
