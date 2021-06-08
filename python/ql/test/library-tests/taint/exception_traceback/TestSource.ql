import python
import semmle.python.security.Exceptions
import semmle.python.web.HttpResponse

from TaintSource src, TaintKind kind
where
  src.isSourceOf(kind) and
  not src.getLocation().getFile().inStdlib()
select src.getLocation().toString(), src.(ControlFlowNode).getNode().toString(), kind
