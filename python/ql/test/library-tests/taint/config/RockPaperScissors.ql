/**
 * @kind path-problem
 */

import python
import semmle.python.dataflow.TaintTracking
import TaintLib
import semmle.python.security.Paths

from RockPaperScissorConfig config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "$@ loses to $@.", src.getNode(), src.getTaintKind().toString(),
  sink.getNode(), sink.getTaintKind().toString()
