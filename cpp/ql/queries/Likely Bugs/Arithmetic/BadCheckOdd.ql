/**
 * @name Bad check for oddness
 * @description Using "x % 2 == 1" to check whether x is odd does not work for
 *              negative numbers.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/incomplete-parity-check
 * @tags reliability
 *       correctness
 *       types
 */

import cpp

from EqualityOperation t, RemExpr lhs, Literal rhs
where
  t.getLeftOperand() = lhs and
  t.getRightOperand() = rhs and
  lhs.getLeftOperand().getUnspecifiedType().(IntegralType).isSigned() and
  lhs.getRightOperand().getValue() = "2" and
  rhs.getValue() = "1"
select t, "Possibly invalid test for oddness. This will fail for negative numbers."
