import python
private import LegacyPointsTo

from ExceptFlowNodeWithPointsTo ex, Value val
where ex.handledException(val, _, _)
select ex.getLocation().getStartLine(), ex.toString(), val.toString()
