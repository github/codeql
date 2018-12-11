import python

import semmle.python.security.Exceptions
import semmle.python.web.HttpResponse

from TaintedNode n, TaintedNode s
where 
    s = n.getASuccessor() and
    not n.getLocation().getFile().inStdlib() and
    not s.getLocation().getFile().inStdlib()
select 
    n.getTrackedValue(), n.getLocation().toString(), n.getNode().getNode().toString(), n.getContext(),
    " --> ",
    s.getTrackedValue(), s.getLocation().toString(), s.getNode().getNode().toString(), s.getContext()
