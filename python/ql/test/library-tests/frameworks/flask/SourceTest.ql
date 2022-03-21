/**
 * @kind path-problem
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import DataFlow::PathGraph

// see `source_test.py`
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "SourceTest" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    source.getLocation().getFile().getShortName().matches("source_test%")
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" and
      sink.(DataFlow::CfgNode).getNode() = call.getAnArg() and
      sink.getLocation().getFile().getShortName().matches("source_test%")
    )
  }
}

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Path text"
