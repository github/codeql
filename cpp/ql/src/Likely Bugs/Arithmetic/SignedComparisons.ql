/**
 * @name Undefined result of signed test for overflow
 * @description Testing for signed integer overflow by adding a value to
 *              a variable (or subtracting a value from a variable) and
 *              then comparing the result to said variable is not defined
 *              by the C or C++ standards.  The comparison may produce an
 *              unintended result, or may be deleted by the compiler
 *              entirely.
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
  (bao instanceof AddExpr or bao instanceof SubExpr) and
  bao.getAnOperand() = va1 and
  ro.getAnOperand() = va2 and
  va1.getTarget() = va2.getTarget() and
  /*
   * if the addition/subtraction (`bao`) has been promoted to a signed type,
   * then the other operand (`va2`) must also be signed and we have a signed
   * comparison
   */

  bao.getFullyConverted().getType().(IntegralType).isSigned()
select ro, "Testing for signed overflow/underflow may produce undefined results."
