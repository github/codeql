/**
 * @name Uncontrolled allocation size
 * @description Allocating memory with a size controlled by an external user can result in
 *              arbitrary amounts of memory being allocated, leading to a crash or a
 *              denial-of-service (DoS) attack.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 7.5
 * @precision high
 * @id rust/uncontrolled-allocation-size
 * @tags reliability
 *       security
 *       external/cwe/cwe-770
 *       external/cwe/cwe-789
 */

import rust
import codeql.rust.Concepts
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.dataflow.internal.DataFlowImpl
import codeql.rust.security.UncontrolledAllocationSizeExtensions

/**
 * A taint-tracking configuration for uncontrolled allocation size vulnerabilities.
 */
module UncontrolledAllocationConfig implements DataFlow::ConfigSig {
  import UncontrolledAllocationSize

  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof Barrier }
}

module UncontrolledAllocationFlow = TaintTracking::Global<UncontrolledAllocationConfig>;

import UncontrolledAllocationFlow::PathGraph

from UncontrolledAllocationFlow::PathNode source, UncontrolledAllocationFlow::PathNode sink
where UncontrolledAllocationFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This allocation size is derived from a $@ and could allocate arbitrary amounts of memory.",
  source.getNode(), "user-provided value"
