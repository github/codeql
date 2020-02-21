
import python

from ExceptFlowNode ex, Object obj
where ex.handledException_objectapi(obj, _, _)
select ex.getLocation().getStartLine(), ex.toString(), obj.toString()