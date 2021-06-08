import python
import semmle.python.dataflow.TaintTracking
import TaintLib

from TaintSource src, TaintSink sink, TaintKind srckind, TaintKind sinkkind
where src.flowsToSink(srckind, sink) and sink.sinks(sinkkind)
select srckind, src.getLocation().toString(), sink.getLocation().getStartLine(),
  sink.(ControlFlowNode).getNode().toString(), sinkkind
