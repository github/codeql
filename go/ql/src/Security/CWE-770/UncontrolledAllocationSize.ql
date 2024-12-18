/**
 * @name Slice memory allocation with excessive size value
 * @description Allocating memory for slices with the built-in make function from user-controlled sources can lead to a denial of service.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id go/uncontrolled-allocation-size
 * @tags security
 *       external/cwe/cwe-770
 */

import go
import semmle.go.security.UncontrolledAllocationSize
import UncontrolledAllocationSize::Flow::PathGraph

from
  UncontrolledAllocationSize::Flow::PathNode source, UncontrolledAllocationSize::Flow::PathNode sink
where UncontrolledAllocationSize::Flow::flowPath(source, sink)
select sink, source, sink, "This memory allocation depends on a $@.", source.getNode(),
  "user-provided value"
