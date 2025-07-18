/**
 * @name Raising `NotImplemented`
 * @description Using `NotImplemented` as an exception will result in a type error.
 * @kind problem
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/raise-not-implemented
 * @tags quality
 *       reliability
 *       error-handling
 */

import python
import semmle.python.ApiGraphs

predicate raiseNotImplemented(Raise raise, Expr notImpl) {
  exists(API::Node n | n = API::builtin("NotImplemented") |
    notImpl = n.getACall().asExpr()
    or
    n.asSource().flowsTo(DataFlow::exprNode(notImpl))
  ) and
  notImpl = raise.getException()
}

from Expr notimpl
where raiseNotImplemented(_, notimpl)
select notimpl, "NotImplemented is not an Exception. Did you mean NotImplementedError?"
