import python
import semmle.python.pointsto.PointsTo
import semmle.python.pointsto.PointsToContext
import semmle.python.objects.ObjectInternal

from CallNode call, SuperInstance sup, BoundMethodObjectInternal bm
where
  call.getFunction().inferredValue() = bm and
  call.getFunction().(AttrNode).getObject().inferredValue() = sup
select call.getLocation().getStartLine(), call.toString(),
  bm.getFunction().getSource().(FunctionObject).getQualifiedName()
