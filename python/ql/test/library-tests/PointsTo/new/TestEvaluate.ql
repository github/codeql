
import python
import semmle.python.pointsto.PointsTo
import semmle.python.pointsto.PointsToContext
import Util


from ControlFlowNode test, ControlFlowNode use, Object val, boolean eval, ClassObject cls, PointsToContext ctx
where 
not use instanceof NameConstantNode and
not use.getNode() instanceof ImmutableLiteral and
PointsTo::points_to(use, ctx, val, cls, _) and
eval = PointsTo::test_evaluates_boolean(test, use, ctx, val, cls, _)
select locate(test.getLocation(), "bc"), test.getNode().toString(), eval.toString(), use.getNode().toString(), val.toString()
