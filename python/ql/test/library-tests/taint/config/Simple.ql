/**
 * @kind path-problem
 */

import python
import semmle.python.dataflow.TaintTracking
import TaintLib

from SimpleConfig config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "$@ flows to $@.", src.getNode(), src.getTaintKind().toString(),
  sink.getNode(), sink.getTaintKind().toString()
