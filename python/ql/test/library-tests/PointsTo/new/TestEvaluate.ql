
import python
import semmle.python.pointsto.PointsTo
import semmle.python.pointsto.PointsToContext
import Util


from ControlFlowNode test, ControlFlowNode use, Value val, boolean eval, PointsToContext ctx
where 
not use instanceof NameConstantNode and
not use.getNode() instanceof ImmutableLiteral and
eval = Conditionals::testEvaluates(test, use, ctx, val, _)
select locate(test.getLocation(), "bc"), test.getNode().toString(), eval.toString(), use.getNode().toString(), val.getSource().toString()
