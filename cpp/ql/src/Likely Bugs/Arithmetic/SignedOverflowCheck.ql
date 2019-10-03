/**
 * @name Undefined result of signed test for overflow
 * @description Testing for overflow by adding a value to a variable
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

from RelationalOperation ro, AddExpr add, VariableAccess va1, VariableAccess va2
where
  ro.getAnOperand() = add and
  add.getAnOperand() = va1 and
  ro.getAnOperand() = va2 and
  va1.getTarget() = va2.getTarget() and
  (not exists(va1.getQualifier()) or va1.getQualifier() = va2.getQualifier()) and 
  /*
   * if the addition (`add`) has been promoted to a signed type,
   * then the other operand (`va2`) must have been likewise promoted and so
   * have a signed comparison
   */

  add.getExplicitlyConverted().getType().(IntegralType).isSigned()
select ro, "Testing for signed overflow may produce undefined results."
