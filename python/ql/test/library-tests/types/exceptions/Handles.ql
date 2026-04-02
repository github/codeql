import python
private import LegacyPointsTo

from ExceptFlowNodeWithPointsTo n, ClassObject cls
where n.handles_objectapi(cls)
select n.getLocation().getStartLine(), cls.toString()
