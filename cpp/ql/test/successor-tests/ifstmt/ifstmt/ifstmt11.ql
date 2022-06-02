/**
 * @name ifstmt11
 * @description If an initialization exists, then the condition is a successor of the initialization.
 */

import cpp

from IfStmt is, Expr e, Stmt s, ControlFlowNode n
where
  s = is.getInitialization() and
  e = is.getCondition() and
  n = s.getASuccessor*() and
  not exists(ControlFlowNode m | m = e.getASuccessor*() | m = n) and
  not exists(ControlFlowNode m | m = e.getAPredecessor*() | m = n)
select is
