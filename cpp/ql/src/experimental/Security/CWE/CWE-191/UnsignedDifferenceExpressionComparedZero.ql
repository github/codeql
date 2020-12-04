/**
 * @name Unsigned difference expression compared to zero
 * @description It is highly probable that the condition is wrong if the difference expression has the unsigned type.
 *              The condition holds in all the cases when difference is not equal to zero. It means that we may use condition not equal.
 *              But the programmer probably wanted to compare the difference of elements.
 * @kind problem
 * @id cpp/unsigned-difference-expression-compared-zero
 * @problem.severity warning
 * @precision medium
 * @tags security
 *       external/cwe/cwe-191
 */

import cpp
import semmle.code.cpp.commons.Exclusions

from RelationalOperation ro, SubExpr sub
where
  not isFromMacroDefinition(ro) and
  ro.getLesserOperand().getValue().toInt() = 0 and
  ro.getGreaterOperand() = sub and
  sub.getFullyConverted().getUnspecifiedType().(IntegralType).isUnsigned()
select ro, "Difference in condition is always greater than or equal to zero"
