/**
 * @name AV Rule 59
 * @description The statements forming the body of an if, else if, else, while, do-while or for statement shall always be enclosed in braces, even if the braces form an empty block.
 * @kind problem
 * @id cpp/jsf/av-rule-59
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

from Stmt parent, Stmt child
where
  not child instanceof BlockStmt and
  (
    child = parent.(IfStmt).getThen()
    or
    child = parent.(WhileStmt).getStmt()
    or
    child = parent.(DoStmt).getStmt()
    or
    child = parent.(ForStmt).getStmt()
    or
    child = parent.(IfStmt).getElse() and not child instanceof IfStmt
  )
select child.findRootCause(),
  "The statements forming the body of an if, else if, else, while, do...while or for statement shall always be enclosed in braces, even if the braces form an empty block."
