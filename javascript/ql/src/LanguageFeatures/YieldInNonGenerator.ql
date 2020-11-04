/**
 * @name Yield in non-generator function
 * @description 'yield' should only be used in generator functions.
 * @kind problem
 * @problem.severity error
 * @id js/yield-outside-generator
 * @tags maintainability
 *       language-features
 *       external/cwe/cwe-758
 * @precision very-high
 */

import javascript

from YieldExpr yield, Function f
where
  f = yield.getEnclosingFunction() and
  not is_generator(f)
select yield, "This yield expression is contained in $@ which is not marked as a generator.",
  f.getFirstToken(), f.describe()
