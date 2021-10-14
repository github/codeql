/**
 * @name AV Rule 198
 * @description The initialization statement in a for loop will only
 *              initialize a single loop parameter.
 * @kind problem
 * @id cpp/jsf/av-rule-198
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

predicate isValidLoopInitialization(Stmt s) {
  s instanceof DeclStmt or
  s.(ExprStmt).getExpr() instanceof AssignExpr
}

from ForStmt for
where
  for.fromSource() and
  not isValidLoopInitialization(for.getInitialization())
select for,
  "AV Rule 198: The initialization statement in a for loop will only initialize a single loop parameter."
