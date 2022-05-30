/**
 * @name Overview from using type-tracking instead of points-to, for both call-graph and
 * argument passing
 * @kind problem
 * @problem.severity recommendation
 * @id py/meta/type-tracking-overview
 * @precision very-low
 */

import python
import CallGraphQuality
import ArgumentPassing

/** Helper predicate to select a single valid AST node, otherwise MRVA will not show results. */
Location firsExprLocation() {
  result =
    min(Expr expr, Location loc |
      exists(loc.getFile().getRelativePath()) and
      loc = expr.getLocation()
    |
      loc
      order by
        loc.getFile().getRelativePath(), loc.getStartLine(), loc.getStartColumn(), loc.getEndLine(),
        loc.getEndColumn()
    )
}

from string part, string tag, int c
where
  part = "call-graph" and
  (
    tag = "SHARED" and
    c =
      count(CallNode call, Target target |
        target.isRelevant() and
        call.(PointsToBasedCallGraph::ResolvableCall).getTarget() = target and
        call.(TypeTrackingBasedCallGraph::ResolvableCall).getTarget() = target
      )
    or
    tag = "NEW" and
    c =
      count(CallNode call, Target target |
        target.isRelevant() and
        not call.(PointsToBasedCallGraph::ResolvableCall).getTarget() = target and
        call.(TypeTrackingBasedCallGraph::ResolvableCall).getTarget() = target
      )
    or
    tag = "MISSING" and
    c =
      count(CallNode call, Target target |
        target.isRelevant() and
        call.(PointsToBasedCallGraph::ResolvableCall).getTarget() = target and
        not call.(TypeTrackingBasedCallGraph::ResolvableCall).getTarget() = target
      )
  )
  or
  part = "argument-passing" and
  (
    tag = "SHARED" and
    c =
      count(ControlFlowNode arg, Parameter param |
        PointsToArgumentPassing::argumentPassing(arg, param) and
        TypeTrackingArgumentPassing::argumentPassing(arg, param)
      )
    or
    tag = "NEW" and
    c =
      count(ControlFlowNode arg, Parameter param |
        not PointsToArgumentPassing::argumentPassing(arg, param) and
        TypeTrackingArgumentPassing::argumentPassing(arg, param)
      )
    or
    tag = "MISSING" and
    c =
      count(ControlFlowNode arg, Parameter param |
        PointsToArgumentPassing::argumentPassing(arg, param) and
        not TypeTrackingArgumentPassing::argumentPassing(arg, param)
      )
  )
select firsExprLocation(), part + " | " + tag + " | " + c as msg order by msg desc
