
import python

from ExceptFlowNode ex, Object obj
where ex.handledException(obj, _, _)
select ex.getLocation().getStartLine(), ex.toString(), obj.toString()