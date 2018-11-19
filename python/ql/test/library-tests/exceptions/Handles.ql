import python

from ExceptFlowNode ex, Object t
where ex.handledException(t,  _, _)
select ex.getLocation().getStartLine(), ex.toString(), t.toString()