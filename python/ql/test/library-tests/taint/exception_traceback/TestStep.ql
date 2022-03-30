import python
import semmle.python.security.Exceptions
import semmle.python.web.HttpResponse

from TaintedNode n, TaintedNode s
where
  s = n.getASuccessor() and
  not n.getLocation().getFile().inStdlib() and
  not s.getLocation().getFile().inStdlib()
select "Taint " + n.getTaintKind(), n.getLocation().toString(), n.getNode().toString(),
  n.getContext(), " --> ", "Taint " + s.getTaintKind(), s.getLocation().toString(),
  s.getNode().toString(), s.getContext()
