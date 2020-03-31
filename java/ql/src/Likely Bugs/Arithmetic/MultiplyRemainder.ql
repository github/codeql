/**
 * @name Multiplication of remainder
 * @description Using the remainder operator with the multiplication operator without adding
 *              parentheses to clarify precedence may cause confusion.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/multiplication-of-remainder
 * @tags maintainability
 *       correctness
 */

import java

from MulExpr e, RemExpr lhs
where
  e.getLeftOperand() = lhs and
  not lhs.isParenthesized() and
  e.getRightOperand().getType().hasName("int")
select e, "Result of a remainder operation multiplied by an integer."
