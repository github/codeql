/**
 * @name Assert statement tests the truth value of a literal constant
 * @description An assert statement testing a literal constant value may exhibit
 *              different behavior when optimizations are enabled.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity recommendation
 * @sub-severity low
 * @precision medium
 * @id py/assert-literal-constant
 */

import python
import semmle.python.filters.Tests

from Assert a, string value
where
  /* Exclude asserts inside test cases */
  not a.getScope().getScope*() instanceof TestScope and
  exists(Expr test | test = a.getTest() |
    value = test.(IntegerLiteral).getN()
    or
    value = "\"" + test.(StrConst).getS() + "\""
    or
    value = test.(NameConstant).toString()
  ) and
  /* Exclude asserts appearing at the end of a chain of `elif`s */
  not exists(If i | i.getElif().getAnOrelse() = a)
select a, "Assert of literal constant " + value + "."
