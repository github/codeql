/**
 * @name Exit from permanent loop
 * @description Permanent loops (like "while(1) {..}") are typically meant to be non-terminating and should not be terminated by other means.
 * @kind problem
 * @id cpp/power-of-10/exit-permanent-loop
 * @problem.severity recommendation
 * @precision low
 * @tags correctness
 *       external/powerof10
 */

import cpp

Stmt exitFrom(Loop l) {
  l.getAChild+() = result and
  (
    result instanceof ReturnStmt
    or
    exists(BreakStmt break | break = result | not l.getAChild*() = break.getTarget())
  )
}

from Loop l, Stmt exit
where
  l.getControllingExpr().getValue().toInt() != 0 and
  exit = exitFrom(l)
select exit, "$@ should not be exited.", l, "This permanent loop"
