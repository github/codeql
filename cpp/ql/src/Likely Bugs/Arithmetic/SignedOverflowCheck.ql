/**
 * @name Undefined result of signed test for overflow
 * @description Testing for oveflow by adding a value to a variable
 *              to see if it "wraps around" works only for
 *              `unsigned` integer values.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/signed-overflow-check
 * @tags reliability
 *       security
 */

import cpp

from RelationalOperation ro, BinaryArithmeticOperation bao, VariableAccess va1, VariableAccess va2
where
  ro.getAnOperand() = bao and
  bao instanceof AddExpr and
  bao.getAnOperand() = va1 and
  ro.getAnOperand() = va2 and
  va1.getTarget() = va2.getTarget() and
  /*
   * if the addition/subtraction (`bao`) has been promoted to a signed type,
   * then the other operand (`va2`) must have been likewise promoted and so
   * have a signed comparison
   */

  bao.getFullyConverted().getType().(IntegralType).isSigned()
select ro, "Testing for signed overflow/underflow may produce undefined results."
