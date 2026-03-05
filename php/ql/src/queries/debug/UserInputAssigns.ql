/**
 * @name Assignments from user input
 * @description Find assignments where RHS is a subscript on a superglobal.
 * @id php/debug/user-input-assigns
 * @kind problem
 */

import codeql.php.AST

from AssignExpr assign, SubscriptExpr sub, VariableName v
where
  assign.getRightOperand() = sub and
  v = sub.getObject() and
  v.getValue() = ["$_GET", "$_POST", "$_REQUEST", "$_COOKIE"]
select assign, "Assignment from " + v.getValue()
