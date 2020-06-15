/**
 * @name Use of externally-controlled delay
 * @description User-controlled delay on scheduling methods can lead to memory leaks
 * @kind path-problem
 * @problem.severity warning
 * @id js/tainted-schedule-method
 * @tags efficiency
 *       maintainability
 */

import javascript
import DataFlow
import DataFlow::PathGraph

class TaintedScheduleMethod extends TaintTracking::Configuration {
  TaintedScheduleMethod() { this = "TaintedScheduleMethod" }
  override predicate isSource(Node node) { node instanceof RemoteFlowSource }
  override predicate isSink(DataFlow::Node sink) {
    DataFlow::globalVarRef("setInterval").getACall().getArgument(1) = sink
    or
    DataFlow::globalVarRef("setTimeout").getACall().getArgument(1) = sink
  }
}

from TaintedScheduleMethod cfg, PathNode source, PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "setTimeout with user-controlled delay from $@.", source.getNode(), "here"
