import python
private import LegacyPointsTo

from ExceptFlowNode ex, Value val
where ex.handledException(val, _, _)
select ex.getLocation().getStartLine(), ex.toString(), val.toString()
