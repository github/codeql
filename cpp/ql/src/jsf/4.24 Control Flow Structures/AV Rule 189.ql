/**
 * @name AV Rule 189
 * @description The goto statement shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-189
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

from GotoStmt s
where
  s.fromSource() and
  not s.breaksFromNestedLoops()
select s, "AV Rule 189: The goto statement shall not be used."
