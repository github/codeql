import python
import semmle.python.web.HttpRequest
import semmle.python.security.strings.Untrusted

from HttpRequestTaintSource source, TaintKind kind
where
  source.isSourceOf(kind) and
  source.getLocation().getFile().getShortName() != "cgi.py"
select source.(ControlFlowNode).getNode(), kind
