import python
import semmle.python.security.TaintTracking
import TaintLib

from TestConfig config, DataFlow::Node sink, TaintKind kind

where config.isSink(sink, kind)
select config, sink.getLocation().toString(), sink.getLocation().getStartLine(), sink.toString(), kind
