/**
 * @name AV Rule 191
 * @description The break statement shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-191
 * @problem.severity recommendation
 * @tags maintainability
 *       external/jsf
 */

import cpp

/*
 * TODO: "The break statement may be used to break out of a single loop provided
 *        the alternative would obscure or otherwise significantly complicate the
 *        control logic."
 */

// whether t is the last statement of s, possibly peeling off blocks
predicate isTerminatingStmt(Stmt s, Stmt t) {
  s = t or isTerminatingStmt(s.(BlockStmt).getLastStmt(), t)
}

from BreakStmt s
where
  s.fromSource() and
  // exclude break statements that terminate switch cases
  not exists(SwitchCase sc | isTerminatingStmt(sc.getLastStmt(), s))
select s, "AV Rule 191: The break statement shall not be used."
