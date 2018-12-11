import python

import ExtensionsLib


from TaintedNode n, TaintedNode s
where s = n.getASuccessor()
select 
    n.getTrackedValue(), n.getLocation().toString(), n.getNode().getNode().toString(), n.getContext(),
    " --> ",
    s.getTrackedValue(), s.getLocation().toString(), s.getNode().getNode().toString(), s.getContext()
