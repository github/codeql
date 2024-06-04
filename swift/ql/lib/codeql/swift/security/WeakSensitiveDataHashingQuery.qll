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
module WeakSensitiveDataHashingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    exists(SensitiveExpr se |
      node.asExpr() = se and
      not se.getSensitiveType() instanceof SensitivePassword // responsibility of the weak password hashing query
    )
  }

  predicate isSink(DataFlow::Node node) { node instanceof WeakSensitiveDataHashingSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof WeakSensitiveDataHashingBarrier }

  predicate isBarrierIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }

  predicate isBarrierOut(DataFlow::Node node) {
    // make sinks barriers so that we only report the closest instance
    isSink(node)
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(WeakSensitiveDataHashingAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

deprecated module WeakHashingConfig = WeakSensitiveDataHashingConfig;

module WeakSensitiveDataHashingFlow = TaintTracking::Global<WeakSensitiveDataHashingConfig>;

deprecated module WeakHashingFlow = WeakSensitiveDataHashingFlow;
