/**
 * @name AV Rule 195
 * @description A switch expression will not represent a Boolean value.
 * @kind problem
 * @id cpp/jsf/av-rule-195
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

from SwitchStmt s
where
  s.fromSource() and
  s.getExpr().getUnderlyingType() instanceof BoolType
select s, "AV Rule 195: A switch expression will not represent a Boolean value."
