import python

from ExceptFlowNode ex, Object val
where ex.handledException_objectapi(val, _, _)
select ex.getLocation().getStartLine(), ex.toString(), val.toString()
