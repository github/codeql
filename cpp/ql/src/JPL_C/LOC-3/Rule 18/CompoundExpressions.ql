/**
 * @name Implicit precedence in compound expression
 * @description In compound expressions with multiple sub-expressions the intended order of evaluation shall be made explicit with parentheses.
 * @kind problem
 * @id cpp/jpl-c/compound-expressions
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

from BinaryOperation parent, BinaryOperation child
where
  parent.getAnOperand() = child and
  not child.isParenthesised() and
  (parent instanceof BinaryBitwiseOperation or child instanceof BinaryBitwiseOperation) and
  // Some benign cases...
  not (parent instanceof BitwiseAndExpr and child instanceof BitwiseAndExpr) and
  not (parent instanceof BitwiseOrExpr and child instanceof BitwiseOrExpr) and
  not (parent instanceof BitwiseXorExpr and child instanceof BitwiseXorExpr)
select parent, "This expression involving bitwise operations should be bracketed."
