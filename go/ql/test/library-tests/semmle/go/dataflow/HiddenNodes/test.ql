/**
 * @kind path-problem
 */

import go
import DataFlow::PathGraph

class Config extends TaintTracking::Configuration {
  Config() { this = "config" }

  override predicate isSource(DataFlow::Node n) {
    n = any(DataFlow::CallNode call | call.getTarget().getName() = "source").getResult()
  }

  override predicate isSink(DataFlow::Node n) {
    n = any(DataFlow::CallNode call | call.getTarget().getName() = "sink").getAnArgument()
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Config c
where c.hasFlowPath(source, sink)
select source, source, sink, "Path"
