/**
 * @name Raising a tuple
 * @description Raising a tuple will result in all but the first element being discarded
 * @kind problem
 * @tags maintainability
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/raises-tuple
 */

import python
import semmle.python.dataflow.new.DataFlow

from Raise r, DataFlow::LocalSourceNode origin
where
  exists(DataFlow::Node exception | exception.asExpr() = r.getException() |
    origin.flowsTo(exception)
  ) and
  origin.asExpr() instanceof Tuple and
  major_version() = 2
/* Raising a tuple is a type error in Python 3, so is handled by the IllegalRaise query. */
select r,
  "Raising a $@ will result in the first element (recursively) being raised and all other elements being discarded.",
  origin, "tuple"
