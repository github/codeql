/**
 * @name AV Rule 209
 * @description The basic types of int, short, long, float and double shall not be used,
 *              but specific-length equivalents should be typedef'd accordingly for
 *              each compiler, and these type names used in the code.
 * @kind problem
 * @id cpp/jsf/av-rule-209
 * @problem.severity recommendation
 * @tags maintainability
 *       portability
 *       external/jsf
 */

import cpp

from Element u, ArithmeticType at
where
  (
    at.hasName("int") or
    at.hasName("short") or
    at.hasName("long") or
    at.hasName("float") or
    at.hasName("double")
  ) and
  u = at.getATypeNameUse() and
  not at instanceof WideCharType
select u, "AV Rule 209: The basic types of int, short, long, float and double shall not be used."
