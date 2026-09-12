/**
 * @name Deserialization of user-controlled data
 * @description Deserializing user-controlled data may allow an attacker to trigger unexpected
 *              code execution, denial of service, or other harmful effects.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id rust/unsafe-deserialization
 * @tags security
 *       external/cwe/cwe-502
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.UnsafeDeserializationExtensions

/**
 * A taint configuration for detecting unsafe deserialization vulnerabilities.
 */
module UnsafeDeserializationConfig implements DataFlow::ConfigSig {
  import UnsafeDeserialization

  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof Barrier }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module UnsafeDeserializationFlow = TaintTracking::Global<UnsafeDeserializationConfig>;

import UnsafeDeserializationFlow::PathGraph

from UnsafeDeserializationFlow::PathNode sourceNode, UnsafeDeserializationFlow::PathNode sinkNode
where UnsafeDeserializationFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "This deserialization operation processes $@ without validation.", sourceNode.getNode(),
  "user-provided data"
