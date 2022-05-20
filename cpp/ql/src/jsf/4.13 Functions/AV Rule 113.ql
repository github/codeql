/**
 * @name AV Rule 113
 * @description Functions will have a single exit point.
 * @kind problem
 * @id cpp/jsf/av-rule-113
 * @problem.severity recommendation
 * @tags maintainability
 *       external/jsf
 */

import cpp

from Function f, Stmt s1, Stmt s2
where
  s1 = f.getAPredecessor().getEnclosingStmt() and
  s2 = f.getAPredecessor().getEnclosingStmt() and
  s1 != s2
select f, "AV Rule 113: Functions will have a single exit point."
