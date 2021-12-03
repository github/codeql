/**
 * @name Key points-to fails for expression.
 * @description Expression does not "point-to" an object which prevents further points-to analysis.
 * @kind problem
 * @problem.severity info
 * @id py/key-points-to-failure
 * @deprecated
 */

import python
import semmle.python.pointsto.PointsTo

predicate points_to_failure(Expr e) {
  exists(ControlFlowNode f | f = e.getAFlowNode() | not PointsTo::pointsTo(f, _, _, _))
}

predicate key_points_to_failure(Expr e) {
  points_to_failure(e) and
  not points_to_failure(e.getASubExpression()) and
  not exists(SsaVariable ssa | ssa.getAUse() = e.getAFlowNode() |
    points_to_failure(ssa.getAnUltimateDefinition().getDefinition().getNode())
  ) and
  not exists(Assign a | a.getATarget() = e)
}

from Attribute e
where key_points_to_failure(e) and not exists(Call c | c.getFunc() = e)
select e, "Expression does not 'point-to' any object, but all its sources do."
