/**
 * @kind path-problem
 *
 * An example configuration.
 * See ExampleConfiguration.expected for the results of running this query.
 */

import python
import DilbertConfig
import semmle.python.security.Paths

from DilbertConfig config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "$@ goes to a $@.", src.getNode(), src.getTaintKind().toString(),
  sink.getNode(), "meeting"
