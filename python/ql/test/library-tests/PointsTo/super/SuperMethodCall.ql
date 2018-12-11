
import python
import semmle.python.pointsto.PointsTo
import semmle.python.pointsto.PointsToContext

from CallNode call, FunctionObject method
where PointsTo::Test::super_method_call(_, call, _, method)
select call.getLocation().getStartLine(), call.toString(), method.getQualifiedName()

