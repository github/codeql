
import python

import semmle.python.web.HttpRequest
import semmle.python.web.HttpResponse
import semmle.python.security.strings.Untrusted
import semmle.python.TestUtils

from TaintSink sink, TaintKind kind
where sink.sinks(kind)
select remove_library_prefix(sink.getLocation()), sink.(ControlFlowNode).getNode().toString(), kind
