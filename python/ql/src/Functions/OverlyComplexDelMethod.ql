/**
 * @name Overly complex `__del__` method
 * @description `__del__` methods may be called at arbitrary times, perhaps never called at all, and should be simple.
 * @kind problem
 * @tags quality
 *       maintainability
 *       complexity
 * @problem.severity recommendation
 * @sub-severity low
 * @precision high
 * @id py/overly-complex-delete
 */

import python
import semmle.python.Metrics

from FunctionMetrics method
where
  method.getName() = "__del__" and
  method.isMethod() and
  method.getCyclomaticComplexity() > 3
select method, "Overly complex '__del__' method."
