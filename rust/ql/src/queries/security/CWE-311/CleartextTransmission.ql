/**
 * @name Cleartext transmission of sensitive information
 * @description Transmitting sensitive information across a network in
 *              cleartext can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id rust/cleartext-transmission
 * @tags security
 *       external/cwe/cwe-319
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.security.SensitiveData
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.CleartextTransmissionExtensions

/**
 * A taint configuration from sensitive information to expressions that are
 * transmitted over a network.
 */
module CleartextTransmissionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof SensitiveData }

  predicate isSink(DataFlow::Node node) { node instanceof CleartextTransmission::Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof CleartextTransmission::Barrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(CleartextTransmission::AdditionalFlowStep s).step(nodeFrom, nodeTo)
  }

  predicate isBarrierIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }
}

module CleartextTransmissionFlow = TaintTracking::Global<CleartextTransmissionConfig>;

import CleartextTransmissionFlow::PathGraph

from CleartextTransmissionFlow::PathNode sourceNode, CleartextTransmissionFlow::PathNode sinkNode
where CleartextTransmissionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The operation '" + sinkNode.getNode().toString() +
    "', transmits data which may contain unencrypted sensitive data from $@.", sourceNode,
  sourceNode.getNode().toString()
