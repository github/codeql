/**
 * Provides a taint-tracking configuration for reasoning about cleartext logging of
 * sensitive data vulnerabilities.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.TaintTracking
private import codeql.swift.security.CleartextLoggingExtensions
private import codeql.swift.security.SensitiveExprs

/**
 * A taint-tracking configuration for cleartext logging of sensitive data vulnerabilities.
 */
module CleartextLoggingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof SensitiveExpr }

  predicate isSink(DataFlow::Node sink) { sink instanceof CleartextLoggingSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof CleartextLoggingBarrier }

  // Disregard paths that contain other paths. This helps with performance.
  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(CleartextLoggingAdditionalFlowStep s).step(n1, n2)
  }
}

/**
 * Detect taint flow of cleartext logging of sensitive data vulnerabilities.
 */
module CleartextLoggingFlow = TaintTracking::Global<CleartextLoggingConfig>;
