/**
 * Provides a taint tracking configuration to find use of broken or weak
 * cryptographic hashing algorithms on sensitive data.
 */

import swift
import codeql.swift.security.SensitiveExprs
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.WeakSensitiveDataHashingExtensions

/**
 * A taint tracking configuration from sensitive expressions to broken or weak
 * hashing sinks.
 */
module WeakHashingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof SensitiveExpr }

  predicate isSink(DataFlow::Node node) { node instanceof WeakSensitiveDataHashingSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof WeakSensitiveDataHashingSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(WeakSensitiveDataHashingAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }
}

module WeakHashingFlow = TaintTracking::Global<WeakHashingConfig>;
