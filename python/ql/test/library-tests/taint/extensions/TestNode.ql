import python

import ExtensionsLib


from TaintedNode n
select n.getTrackedValue(), n.getLocation().toString(), n.getNode().getNode().toString(), n.getContext()

