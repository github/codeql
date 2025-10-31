import python
private import LegacyPointsTo

from NameNode n, Object value, ClassObject cls
where n.getId() = "self" and n.(ControlFlowNodeWithPointsTo).refersTo(value, cls, _)
select n.getNode().getLocation().getStartLine(), value.toString(), cls.toString()
