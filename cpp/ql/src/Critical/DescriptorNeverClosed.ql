/**
 * @name Open descriptor never closed
 * @description A function always returns before closing a socket or file that was opened in the function. Closing resources in the same function that opened them ties the lifetime of the resource to that of the function call, making it easier to avoid and detect resource leaks.
 * @kind problem
 * @id cpp/descriptor-never-closed
 * @problem.severity warning
 * @tags efficiency
 *       security
 *       external/cwe/cwe-775
 */
import semmle.code.cpp.pointsto.PointsTo

predicate closed(Expr e)
{
  exists(FunctionCall fc |
    fc.getTarget().hasQualifiedName("close") and
    fc.getArgument(0) = e)
}

class ClosedExpr extends PointsToExpr
{
  ClosedExpr() { closed(this) }
  override predicate interesting() { closed(this) }
}

from Expr alloc
where allocateDescriptorCall(alloc)
  and not exists(ClosedExpr closed | closed.pointsTo() = alloc)
select alloc, "This file descriptor is never closed"
