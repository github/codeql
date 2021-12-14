/**
 * @name AV Rule 199
 * @description The increment expression in a for loop will only update
 *              a single loop parameter.
 * @kind problem
 * @id cpp/jsf/av-rule-199
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

predicate isValidLoopUpdate(Expr e) {
  e instanceof CrementOperation or
  e instanceof AssignExpr or
  e instanceof FunctionCall // this is to account for overloaded operators
}

from ForStmt for
where
  for.fromSource() and
  not isValidLoopUpdate(for.getUpdate())
select for,
  "AV Rule 199: The increment expression in a for loop will only update a single for loop parameter."
