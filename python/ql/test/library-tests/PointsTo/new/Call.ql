import python
import Util

from ControlFlowNode call, FunctionObject func
where call = func.getACall()
select locate(call.getLocation(), "abdglq"), call.toString(), func.getQualifiedName()
