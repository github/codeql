import python
import semmle.python.web.HttpRequest
import semmle.python.security.strings.Untrusted

from HttpRequestTaintSource source, TaintKind kind
where source.isSourceOf(kind)
select source.(ControlFlowNode).getNode(), kind
