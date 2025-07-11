/** Helper definitions for reasoning about comparison methods. */

import python
import semmle.python.ApiGraphs

/** Holds if `cls` has the `functools.total_ordering` decorator. */
predicate totalOrdering(Class cls) {
  API::moduleImport("functools")
      .getMember("total_ordering")
      .asSource()
      .flowsTo(DataFlow::exprNode(cls.getADecorator()))
}
