/**
 * @name Size computation for allocation may overflow
 * @description When computing the size of an allocation based on the size of a large object,
 *              the result may overflow and cause a runtime panic.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision high
 * @id go/allocation-size-overflow
 * @tags security
 *       external/cwe/cwe-190
 */

import go
import DataFlow::PathGraph
import semmle.go.security.AllocationSizeOverflow

from
  AllocationSizeOverflow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink,
  DataFlow::Node allocsz
where
  cfg.hasFlowPath(source, sink) and
  cfg.isSink(sink.getNode(), allocsz)
select sink, source, sink,
  "This operation, which is used in an $@, involves a potentially large $@ and might overflow.",
  allocsz, "allocation", source, "value"
