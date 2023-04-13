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
import AllocationSizeOverflow::TaintConfiguration::PathGraph
import semmle.go.security.AllocationSizeOverflow

from
  AllocationSizeOverflow::TaintConfiguration::PathNode source,
  AllocationSizeOverflow::TaintConfiguration::PathNode sink, DataFlow::Node allocsz
where
  AllocationSizeOverflow::TaintConfiguration::flowPath(source, sink) and
  AllocationSizeOverflow::isSinkWithAllocationSize(sink.getNode(), allocsz)
select sink, source, sink,
  "This operation, which is used in an $@, involves a $@ and might overflow.", allocsz,
  "allocation", source, "potentially large value"
