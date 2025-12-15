/**
 * @name points-to fails for expression
 * @description Expression does not "point-to" an object which prevents type inference.
 * @kind problem
 * @id py/points-to-failure
 * @problem.severity info
 * @tags debug
 * @deprecated
 */

import python
private import LegacyPointsTo

from Expr e
where exists(ControlFlowNodeWithPointsTo f | f = e.getAFlowNode() | not f.refersTo(_))
select e, "Expression does not 'point-to' any object."
