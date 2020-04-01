import python

from ExceptFlowNode n, ClassObject cls
where n.handles_objectapi(cls)
select n.getLocation().getStartLine(), cls.toString()
