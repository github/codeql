/**
 * @name Sign check of bitwise operation
 * @description Checking the sign of a bitwise operation often has surprising
 *              edge cases.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/bitwise-sign-check
 * @tags reliability
 *       correctness
 */

import cpp

from RelationalOperation e, BinaryBitwiseOperation lhs
where
  lhs = e.getGreaterOperand() and
  lhs.getActualType().(IntegralType).isSigned() and
  forall(int op | op = lhs.(BitwiseAndExpr).getAnOperand().getValue().toInt() | op < 0) and
  e.getLesserOperand().getValue() = "0" and
  not e.isAffectedByMacro()
select e, "Potential unsafe sign check of a bitwise operation."
