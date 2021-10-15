/**
 * @name Sign check of bitwise operation
 * @description Checking the sign of the result of a bitwise operation may yield unexpected results.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/bitwise-sign-check
 * @tags reliability
 *       correctness
 */

import java

from ComparisonExpr e
where
  e.isStrict() and
  e.getGreaterOperand() instanceof BitwiseExpr and
  e.getLesserOperand().(IntegerLiteral).getIntValue() = 0
select e, "Sign check of a bitwise operation."
