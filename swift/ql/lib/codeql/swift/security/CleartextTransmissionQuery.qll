/**
 * Provides a taint-tracking configuration for reasoning about cleartext
 * transmission vulnerabilities.
 */

import swift
import codeql.swift.security.SensitiveExprs
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.CleartextTransmissionExtensions

/**
 * A taint configuration from sensitive information to expressions that are
 * transmitted over a network.
 */
module CleartextTransmissionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof SensitiveExpr }

  predicate isSink(DataFlow::Node node) { node instanceof CleartextTransmissionSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof CleartextTransmissionBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(CleartextTransmissionAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }

  predicate isBarrierIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }
}

/**
 * Detect taint flow of sensitive information to expressions that are transmitted over
 * a network.
 */
module CleartextTransmissionFlow = TaintTracking::Global<CleartextTransmissionConfig>;
