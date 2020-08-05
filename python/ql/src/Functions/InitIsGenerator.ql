/**
 * @name __init__ method is a generator
 * @description __init__ method is a generator.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/init-method-is-generator
 */

import python

from Function f
where
  f.isInitMethod() and
  (exists(Yield y | y.getScope() = f) or exists(YieldFrom y | y.getScope() = f))
select f, "__init__ method is a generator."
