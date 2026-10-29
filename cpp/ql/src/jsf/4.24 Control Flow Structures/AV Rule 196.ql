/**
 * @name No trivial switch statements
 * @description Using a switch statement when there are fewer than two non-default cases leads to unclear code.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/trivial-switch
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

from SwitchStmt s
where
  s.fromSource() and
  count(SwitchCase sc | sc.getSwitchStmt() = s and not sc instanceof DefaultCase) < 2 and
  not exists(s.getGeneratingMacro())
select s,
  "This switch statement should either handle more cases, or be rewritten as an if statement."
