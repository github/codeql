import python
import Util

from ControlFlowNode f, ControlFlowNode x
where f.refersTo(theNoneObject(), _, x)
select locate(f.getLocation(), "abcdghijklmopqr"), f.toString(), x.getLocation().getStartLine()
