/**
 * @name Open descriptor never closed
 * @description Functions that always return before closing the socket or file they opened leak resources.
 * @kind problem
 * @id cpp/descriptor-never-closed
 * @problem.severity warning
 * @tags efficiency
 *       security
 *       external/cwe/cwe-775
 */

import semmle.code.cpp.pointsto.PointsTo

predicate closed(Expr e) {
  exists(FunctionCall fc |
    fc.getTarget().hasGlobalOrStdName("close") and
    fc.getArgument(0) = e
  )
}

class ClosedExpr extends PointsToExpr {
  ClosedExpr() { closed(this) }

  override predicate interesting() { closed(this) }
}

from Expr alloc
where
  allocateDescriptorCall(alloc) and
  not exists(ClosedExpr closed | closed.pointsTo() = alloc)
select alloc, "This file descriptor is never closed"
