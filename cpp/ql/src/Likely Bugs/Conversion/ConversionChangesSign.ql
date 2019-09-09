/**
 * @name Conversion changes sign
 * @description Finds conversions from unsigned to signed.
 * @kind problem
 * @id cpp/conversion-changes-sign
 * @problem.severity warning
 * @tags reliability
 */

import cpp

from Expr e1, Cast e2, IntegralType it1, IntegralType it2
where
  e2 = e1.getConversion() and
  e2.isImplicit() and
  it1 = e1.getUnderlyingType() and
  it2 = e2.getUnderlyingType() and
  (
    it1.isUnsigned() and it2.isSigned() and it1.getSize() >= it2.getSize()
    or
    it1.isSigned() and it2.isUnsigned()
  ) and
  not (
    e1.isConstant() and
    0 <= e1.getValue().toInt() and
    e1.getValue().toInt() <= ((it2.getSize() * 8 - 1) * 2.log()).exp()
  ) and
  not e1.isConstant()
select e1,
  "Conversion between signed and unsigned types " + it1.toString() + " and " + it2.toString() + "."
