import python
import semmle.python.pointsto.PointsTo
import semmle.python.pointsto.PointsToContext
import Util

from
  ControlFlowNode test, ControlFlowNode use, ObjectInternal val, boolean eval, PointsToContext ctx,
  ControlFlowNode origin, string what
where
  not use instanceof NameConstantNode and
  not use.getNode() instanceof ImmutableLiteral and
  eval = Conditionals::testEvaluates(test, use, ctx, val, origin) and
  (
    what = val.getSource().(Object).toString()
    or
    not exists(val.getSource()) and what = origin.getNode().toString()
  )
select locate(test.getLocation(), "bc"), test.getNode().toString(), eval.toString(),
  use.getNode().toString(), what
