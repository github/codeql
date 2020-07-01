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
  // `lhs > 0` (or `0 < lhs`)
  // (note that `lhs < 0`, `lhs >= 0` or `lhs <= 0` all imply that the signedness of
  //  `lhs` is understood, so should not be flagged).
  (e instanceof GTExpr or e instanceof LTExpr) and
  e.getGreaterOperand() = lhs and
  e.getLesserOperand().getValue() = "0" and
  // lhs is signed
  lhs.getActualType().(IntegralType).isSigned() and
  // if `lhs` has the form `x & c`, with constant `c`, `c` is negative
  forall(int op | op = lhs.(BitwiseAndExpr).getAnOperand().getValue().toInt() | op < 0) and
  // exception for cases involving macros
  not e.isAffectedByMacro()
select e, "Potential unsafe sign check of a bitwise operation."
