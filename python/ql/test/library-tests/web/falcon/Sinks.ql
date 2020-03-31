import python
import semmle.python.web.HttpRequest
import semmle.python.web.HttpResponse
import semmle.python.security.strings.Untrusted

from TaintSink sink, TaintKind kind
where sink.sinks(kind)
select sink.getLocation().toString(), sink.(ControlFlowNode).getNode().toString(), kind
