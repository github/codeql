import python
import semmle.python.pointsto.PointsTo
import semmle.python.objects.ObjectInternal
import semmle.python.pointsto.PointsToContext

from
  ControlFlowNode test, ControlFlowNode use, ObjectInternal val, boolean eval, PointsToContext ctx
where
  PointsTo::pointsTo(use, ctx, val, _) and
  eval = Conditionals::testEvaluates(test, use, ctx, val, _)
select test.getLocation().getStartLine(), test.getNode().toString(), eval.toString(),
  use.getNode().toString(), val.toString()
