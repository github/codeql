/**
 * @name Undefined result of signed test for overflow
 * @description Testing for overflow by adding a value to a variable
 *              to see if it "wraps around" works only for
 *              `unsigned` integer values.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/signed-overflow-check
 * @tags reliability
 *       security
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

private predicate sameAccess(VariableAccess va1, VariableAccess va2) {
  globalValueNumber(va1) = globalValueNumber(va2)
}

from RelationalOperation ro, AddExpr add, VariableAccess va1, VariableAccess va2
where
  ro.getAnOperand() = add and
  add.getAnOperand() = va1 and
  ro.getAnOperand() = va2 and
  sameAccess(va1, va2) and
  add.getExplicitlyConverted().getType().(IntegralType).isSigned() and
  va2.getExplicitlyConverted().getType().(IntegralType).isSigned()
select ro, "Testing for signed overflow may produce undefined results."
