import python

from NameNode n, Object value, ClassObject cls
where n.getId() = "self" and n.refersTo(value, cls, _)
select n.getNode().getLocation().getStartLine(), value.toString(), cls.toString()
