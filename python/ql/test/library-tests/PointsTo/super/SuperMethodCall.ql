import python
private import LegacyPointsTo
import semmle.python.pointsto.PointsTo
import semmle.python.pointsto.PointsToContext
import semmle.python.objects.ObjectInternal

from CallNode call, SuperInstance sup, BoundMethodObjectInternal bm
where
  call.getFunction().(ControlFlowNodeWithPointsTo).inferredValue() = bm and
  call.getFunction().(AttrNode).getObject().(ControlFlowNodeWithPointsTo).inferredValue() = sup
select call.getLocation().getStartLine(), call.toString(),
  bm.getFunction().getSource().(FunctionObject).getQualifiedName()
