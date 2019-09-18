

import python

from ExceptFlowNode n, ClassObject cls
where n.handles(cls)
select n.getLocation().getStartLine(), cls.toString()
