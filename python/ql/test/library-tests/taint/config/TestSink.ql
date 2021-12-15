import python
import semmle.python.dataflow.TaintTracking
import TaintLib

from TestConfig config, DataFlow::Node sink, TaintKind kind
where config.isSink(sink, kind)
select sink.getLocation().toString(), config, sink.toString(), kind
