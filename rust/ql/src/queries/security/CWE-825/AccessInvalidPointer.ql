/**
 * @name Access of invalid pointer
 * @description Dereferencing an invalid or dangling pointer causes undefined behavior and may result in memory corruption.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id rust/access-invalid-pointer
 * @tags reliability
 *       security
 *       external/cwe/cwe-476
 *       external/cwe/cwe-825
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.AccessInvalidPointerExtensions
import AccessInvalidPointerFlow::PathGraph

/**
 * A data flow configuration for accesses to invalid pointers.
 */
module AccessInvalidPointerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof AccessInvalidPointer::Source }

  predicate isSink(DataFlow::Node node) { node instanceof AccessInvalidPointer::Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof AccessInvalidPointer::Barrier }

  predicate isBarrierOut(DataFlow::Node node) {
    // make sinks barriers so that we only report the closest instance
    isSink(node)
  }
}

module AccessInvalidPointerFlow = TaintTracking::Global<AccessInvalidPointerConfig>;

from AccessInvalidPointerFlow::PathNode sourceNode, AccessInvalidPointerFlow::PathNode sinkNode
where AccessInvalidPointerFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "This operation dereferences a pointer that may be $@.", sourceNode.getNode(), "invalid"
