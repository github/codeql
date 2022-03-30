/**
 * @name Exit from permanent loop
 * @description Permanent loops (like "while(1) {..}") are typically meant to be non-terminating and should not be terminated by other means.
 * @kind problem
 * @id cpp/jpl-c/exit-nonterminating-loop
 * @problem.severity warning
 * @tags correctness
 *       external/jpl
 */

import cpp

predicate markedAsNonterminating(Loop l) {
  exists(Comment c | c.getContents().matches("%@non-terminating@%") | c.getCommentedElement() = l)
}

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
  markedAsNonterminating(l) and
  exit = exitFrom(l)
select exit, "$@ should not be exited.", l, "This permanent loop"
